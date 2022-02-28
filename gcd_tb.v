module gcd_tb;
	reg clk;
	reg nrst;		
	reg [13:0] in_b;
	reg [13:0] in_a;
	wire [13:0] gcd;	
	wire valid;	
	reg [13:0] gcd_tcl;
	integer f_read;		// file to read from
	integer f_write;	// file to write to	

	//instantiation
	gcd DUT (.clk(clk),.nrst(nrst),.in_a(in_a),.in_b(in_b),.gcd(gcd),.valid(valid));

	// SDF Configuration
        //`ifdef BACKANNOTATION 
	initial 
	 begin 
	$sdf_annotate("/project/tsmc65/users/orgadyh/ws/DVD2022/hw9/export/gcd.final.sdf", DUT,, "sdf.log" , "MAXIMUM");
 	 end 
 	//`endif
	


	always
		#5 clk = ~clk;




   initial begin
	clk = 1'b1;
	nrst = 1'b0; // Activate asynchronous reset
  	// Monitor changes
	$monitor("%t: clk=%b nrst=%b in_a=%d in_b=%d gcd=%d valid=%b",$time,clk,nrst,in_a,in_b,gcd,valid);

	f_read = $fopen("/project/tsmc65/users/orgadyh/ws/DVD2022/hw9/inputs/325010809-gcd.txt","r");	//open file to read
	f_write = $fopen("/project/tsmc65/users/orgadyh/ws/DVD2022/hw9/reports/output.txt","w");	//open file to write
	$fwrite(f_write,"# EX_9 Yahel Orgad 325010809\n");
	$fwrite(f_write,"First Number	Second Number	GCD from file	GCD from SM	pass/fail\n");
	$fwrite(f_write,"------------	-------------	-------------	-----------	-------\n");

		while ($feof(f_read)==0)	//do it until reached to end of the read file 
		begin
			//#10
			nrst = 1'b0;
			$fscanf(f_read,"%d		%d		%d\n",in_a,in_b,gcd_tcl);
			#15 nrst = 1'b1;
			wait (valid==1'b1) #20;	//wait until result are ready
		end		
		$fclose(f_write);
		#20 $finish;

  end

  always @(posedge valid)	//when result are ready. put it in the file 
		if (gcd_tcl==gcd)
			$fwrite(f_write,"%d		%d		%d		%d		pass\n",in_a,in_b,gcd_tcl,gcd);
		else 
		    $fwrite(f_write,"%d		%d		%d		%d		fail\n",in_a,in_b,gcd_tcl,gcd);
		

endmodule
