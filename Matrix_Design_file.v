`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2020 08:06:16
// Design Name: 
// Module Name: Matrix
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Matrix(clk, Din, Dout, rst, flag);
input wire clk;
input wire rst;
input wire [31:0] Din;

output wire [31:0]Dout;

output reg flag;


reg en2, we1, we2, enc1, enc2, wec1, wec2, flag2;
reg [2:0] state;
reg [13:0] size = 100, count, i, j, k, addr1, addr2, addrc;
reg [31:0] alpha, beta;
reg [31:0] temp1, temp2, temp3, aat, res;

wire [31:0] bc, aa, aata;
wire [31:0] sum;



wire [31:0] Dout1, Dout2, Doutc;




blk_mem_gen_0 R1(.clka(clk), .clkb(clk), .addra(addr1), .addrb(addr2), .dina(Din), .dinb(Din), .douta(Dout1), .doutb(Dout2), .wea(we1), .web(we2), .ena(1), .enb(en2));

blk_mem_gen_0 R2(.clka(clk), .clkb(clk), .addra(addrc), .addrb(addrc), .dina(bc), .dinb(sum), .douta(Dout), .doutb(Doutc), .wea(wec1), .web(wec2), .ena(enc1), .enb(enc2));

mult_gen_0 M1(.CLK(clk), .A(temp1), .B(temp2), .P(aa));
mult_gen_0 M2(.CLK(clk), .A(aa), .B(alpha), .P(aata)); // Alpha
mult_gen_0 M3(.CLK(clk), .A(Din), .B(beta), .P(bc)); // Beta

c_addsub_0 A(.CLK(clk), .A(aat), .B(Doutc), .S(sum));


always@(posedge clk)
begin
    if(rst)begin
        state <= 3'b000;
        count <= 0;
        
        i <= 0;
        j <= 0;
        k <= 0;
        
        en2 <= 0;
        
        we1 <= 0;
        we2 <= 0;
        
        enc1 <= 1;
        enc2 <= 0;
        
        wec1 <= 0;
        wec2 <= 0;
        
        temp1 <= 0;
        temp2 <= 0;
        temp3 <= 0;
        
        aat <= 0;
        res <= 0;
        
        flag <= 0;
        flag2 <= 0;
        addr1 <= 0;
        addr2 <= 0;
        addrc <= 0;

    end
    
    else 
    case(state)
        
        3'b000:begin
            alpha <= Din;
            state <= 3'b001;
        end
        
        3'b001:begin
            beta <= Din;
            state <= 3'b010;
            we1 <= 1;
        end
        
        3'b010:begin
        case (count)
            size*size: begin
                addr1 <= 0;
                count <= 0;
                state <=3'b011;
                we1 <= 0;
                en2 <= 1;
                addr2 <= 0;
            end
            
            default: begin
                addr1 <= count;
                count <= count + 1;
                state <= 3'b010;
                end
                endcase
        end
        
        
        3'b011:begin
            case (count)
                size*size + 6: begin
                    addrc <= 0;
                    state <=3'b100;
                    wec1 <= 0;
                    enc1 <= 0;
                    enc2 <= 1;
                    count<= 0;      
                end
                
                0:begin
                    count <= count + 1;
                    state <= 3'b011;
                end
                
                1:begin                
                    count <= count + 1;
                    state <= 3'b011;
                end
                
                2:begin                
                    count <= count + 1;
                    state <= 3'b011;
                end 
                
                
                3:begin                                   
                    count <= count + 1; 
                    state <= 3'b011;                  
                end 
                
                4:begin                
                    count <= count + 1;
                    state <= 3'b011;
                end
                
                5:begin                
                    count <= count + 1;
                    state <= 3'b011;
                end                     
                
                6: begin
                    wec1 <= 1;
                    count <= count + 1;
                    state <= 3'b011;
                end
                
                default: begin
                    addrc <= addrc + 1;
                    count <= count + 1;
                    state <= 3'b011;
                    end
                    endcase
            end
          
        3'b100:begin
            k <= k + 1;
            addr1 <= addr1 + 1;
            addr2 <= addr2 + 1;
            //clr <= 0;
            state <= 3'b101;
        end
        
        3'b101:begin
            case(k)
            size - 1:begin
                k <= 0;
                aat <= aata + aat;
                state <= 3'b101;
                

                case(j)
                    size - 1:begin
                        j <= 0;
                        i <= i + 1;
                        addr1 <= (i + 1) * size;
                        addr2 <= 0;
                    end
                    default: begin
                        addr1 <= i * size;
                        addr2 <= (j + 1) * size;
                        j <= j + 1;
                        end
                endcase
            end
            
            14:begin
                aat <= aata;
                //res <= aat + Doutc;
                
                addr1 <= addr1 + 1;
                addr2 <= addr2 + 1;
                k <= k + 1;
                state <= 3'b101;
            end
            
            
           
            15:begin
                aat <= aata + aat;
                
                if(flag2 == 1)
                     wec2 <= 1;
                     
                 addr1 <= addr1 + 1;
                 addr2 <= addr2 + 1;
                 k <= k + 1;        
                 state <= 3'b101;   
       
            end
            
             16:begin   
               if(addrc == size * size)begin
                    state <= 3'b110;
                    wec2 <= 0;
                    addrc <= 0;
                    enc1 <= 1;
                    enc2 <= 0;
                end
                else begin
                    state <= 3'b101;
                    addr1 <= addr1 + 1;
                    addr2 <= addr2 + 1;
                    k <= k + 1;
                    aat <= aata + aat;
                    if(wec2 == 1)begin
                        wec2 <= 0;
                        addrc <= addrc + 1;
                    end
                end
            end
            
            default: begin  
            
                addr1 <= addr1 + 1;
                addr2 <= addr2 + 1;
                
                k <= k + 1;
                state <= 3'b101;
                aat <= aata + aat;
            end
            endcase
            
            if(count == 14)
                flag2 <= 1;
            
            temp1<= Dout1;
            temp2 <= Dout2;
            count <= count + 1;
  
        end
                
        3'b110:begin
            case(addrc)
            size*size: begin
                flag <= 0;
                state <= 3'b110;
            end
            
            default: begin
                addrc <= addrc + 1;
                flag <= 1;
                state <= 3'b110;
            end
            endcase
                    
                end         
    endcase
   
end
endmodule
