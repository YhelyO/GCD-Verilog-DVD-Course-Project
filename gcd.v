// EX_5 GCD Max & Subtract Yahel Orgad 325010809
module gcd #(parameter GCD_LENGTH = 14)  (
input clk, // Clock input
input nrst, // Reset, active on negative edge
input [GCD_LENGTH-1:0] in_a, // first gcd input
input [GCD_LENGTH-1:0] in_b, // second gcd input
output [GCD_LENGTH-1:0] gcd, // gcd output
output valid // Indicator that gcd output is valid
) ;
 // Regs
  reg [GCD_LENGTH-1:0] a;  // first gcd reg 
  reg [GCD_LENGTH-1:0] b;  // second gcd reg 
  reg [GCD_LENGTH-1:0] next_a; 
  reg [GCD_LENGTH-1:0] next_b;
  reg [GCD_LENGTH-1:0] gcd;
  reg valid;
  reg [5:0] state,next_state;

 // One-hot Enumeration of the States
  localparam INIT  = 6'b000001;
  localparam IDLE  = 6'b000010;
  localparam ABIG = 6'b000100; 
  localparam BBIG = 6'b001000;
  localparam FINALVALID = 6'b010000;
  localparam FINAL = 6'b100000;


// Combinational block - compute next state
  always @*
	begin
	  next_a = a;
	  next_b = b;
	  gcd = 0;
	  valid = 0;
	  next_state = 0;

	case (state)
	  INIT: begin
		next_state = IDLE;
		next_a = in_a;
		next_b = in_b;
		end

	  IDLE: begin
	
		if (nrst) begin
		  gcd = 14'd0;
		  valid = 1'd0;
		end

		if (a==b)
		  next_state = FINALVALID;
		else if (a>b)
		  next_state = ABIG;
		else 
		  next_state = BBIG;
		end

	  ABIG: begin
		if (a==b)
		  next_state = FINALVALID;
		else if (a>b)
		 begin
			if(b==0)
				next_b = a;
			else
	 	 		next_a = a - b;
		  next_state = ABIG;
		end
		else 
		  next_state = BBIG;
		end
	  BBIG: begin
		if (a==b)
		  next_state = FINALVALID;
		else if (a>b)
		  next_state = ABIG;
		else 
		   begin
			if(a==0)
				next_a = b;
			else
	 			next_b = b - a;

		  next_state = BBIG;
		   end
		end
	  FINALVALID: begin
		gcd = a;
		valid = 1'd1;
		next_state = FINAL;
		end
	  FINAL: begin
		gcd = a;
		valid = 1'd0;
		next_state = FINAL;
		end
	  default: begin
		   next_state = 5'bx;
		   $display("%t: State machine not initialized\n",$time);
		 end
	endcase	
	end
//Sequntial Block
//State Registers def
  always @(posedge clk or negedge nrst)
	if (!nrst) begin
	   state <= INIT;
		end

	else begin
	   state <= next_state;
	end

 always @(posedge clk or negedge nrst)
	if (!nrst) begin
	   a <= 14'd0;
		end

	else begin
	   a <= next_a;
	end

 always @(posedge clk or negedge nrst)
	if (!nrst) begin
	   b <= 14'd0;
		end

	else begin
	   b <= next_b;
	end

endmodule	
			

