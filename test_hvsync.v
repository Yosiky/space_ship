`include "hvsync_generator.v"
/*
A bouncing ball using absolute coordinates.
*/

module ball_absolute_top(clk, reset, hsync, vsync, rgb, switches_p1);
  localparam size_ship_x = 12;
  localparam size_ship_y = 10;
  input clk;
  input reset;
  input [7:0] switches_p1;
  output hsync, vsync;
  output [2:0] rgb;
  wire display_on;
  wire [8:0] hpos;
  wire [8:0] vpos;
  reg [8:0] score;
  reg [8:0] posx;
  reg [8:0] posy;
  reg [8:0] go_one;
  reg [8:0] go_two;
  reg [8:0] go_three;
  reg [8:0] go_four;
  wire [3:0] flag_go;
  wire [5:0] met_col;
  
  wire my_res;
  assign my_res = flag[0][0] || flag[0][1] || flag[1][0] || flag[1][1] ||
    flag[2][0] || flag[2][1] || flag[3][0] || flag[3][1];
  // video sync generator
  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );
  
  ship_bitmap sprite(.x(x_value[3:0]), 
                     .y(y_value[3:0]), 
                     .flag(ship));
  
  enemy_bitmap sprite_enemy(.x(x_value_enemy[0][4:0]),
                            .y(y_value_enemy[0][3:0]),
                            .flag(meteor[0]));
  enemy_bitmap sprite_enemy_two(.x(x_value_enemy[1][4:0]),
                            .y(y_value_enemy[1][3:0]),
                            .flag(meteor[1]));
  enemy_bitmap sprite_enemy_three(.x(x_value_enemy[2][4:0]),
                            .y(y_value_enemy[2][3:0]),
                            .flag(meteor[2]));
  enemy_bitmap sprite_enemy_fouth(.x(x_value_enemy[3][4:0]),
                            .y(y_value_enemy[3][3:0]),
                            .flag(meteor[3]));
  
  collider #(2, 2, 11, 11, 30, 11) one(.hpos1(posx), 
                               .hpos2(enemy_posx[0]), 
                               .vpos1(posy), 
                               .vpos2(enemy_posy[0]), 
                               .hor_collide(flag[0][0]), 
                               .ver_collide(flag[0][1]));
  collider #(2, 2, 11, 11, 30, 11) two(.hpos1(posx), 
                               .hpos2(enemy_posx[1]), 
                               .vpos1(posy), 
                               .vpos2(enemy_posy[1]), 
                               .hor_collide(flag[1][0]), 
                               .ver_collide(flag[1][1]));
  collider #(2, 2, 11, 11, 30, 11) three(.hpos1(posx), 
                                 .hpos2(enemy_posx[2]), 
                               .vpos1(posy), 
                                 .vpos2(enemy_posy[2]), 
                                 .hor_collide(flag[2][0]), 
                                 .ver_collide(flag[2][1]));
  collider #(2, 2, 11, 11, 30, 11) four(.hpos1(posx), 
                                .hpos2(enemy_posx[3]), 
                               .vpos1(posy), 
                                .vpos2(enemy_posy[3]), 
                                .hor_collide(flag[3][0]), 
                                .ver_collide(flag[3][1]));
  
  collider_v2 #(2, 2, 30, 11, 30, 11) stolk_one(.hpos1(enemy_posx[0]), 
                                                .hpos2(enemy_posx[1]), 
                                                .vpos1(enemy_posy[0]), 
                                                .vpos2(enemy_posy[1]), 
                                                .collide(met_col[0]));
  collider_v2 #(2, 2, 30, 11, 30, 11) stolk_two(.hpos1(enemy_posx[0]), 
                                                .hpos2(enemy_posx[2]), 
                                                .vpos1(enemy_posy[0]), 
                                                .vpos2(enemy_posy[2]), 
                                                .collide(met_col[1]));
  collider_v2 #(2, 2, 30, 11, 30, 11) stolk_three(.hpos1(enemy_posx[0]), 
                                                  .hpos2(enemy_posx[3]), 
                                                .vpos1(enemy_posy[0]), 
                                                  .vpos2(enemy_posy[3]), 
                                                  .collide(met_col[2]));
  collider_v2 #(2, 2, 30, 11, 30, 11) stolk_four(.hpos1(enemy_posx[1]), 
                                                 .hpos2(enemy_posx[2]), 
                                                 .vpos1(enemy_posy[1]), 
                                                 .vpos2(enemy_posy[2]), 
                                                 .collide(met_col[3]));
  collider_v2 #(2, 2, 30, 11, 30, 11) stolk_five(.hpos1(enemy_posx[1]), 
                                                 .hpos2(enemy_posx[3]), 
                                                 .vpos1(enemy_posy[1]), 
                                                 .vpos2(enemy_posy[3]), 
                                                 .collide(met_col[4]));
  collider_v2 #(2, 2, 30, 11, 30, 11) stolk_six(.hpos1(enemy_posx[2]), 
                                                 .hpos2(enemy_posx[3]), 
                                                 .vpos1(enemy_posy[2]), 
                                                 .vpos2(enemy_posy[3]), 
                                                 .collide(met_col[5]));
  
  
  wire [1:0] flag[0:3];                       
  wire [8:0] x_value = hpos < posx  || posx + size_ship_x - 1 < hpos ? 0 : hpos - posx;
  wire [8:0] y_value = vpos < posy  || posy + size_ship_y - 1 < vpos ? 0 : vpos - posy;
  
  wire [8:0] x_value_enemy[0:3]; 
  assign x_value_enemy[0] = hpos < enemy_posx[0] || enemy_posx[0] + 32 < hpos ? 0 : hpos - enemy_posx[0];
  assign x_value_enemy[1] = hpos < enemy_posx[1] || enemy_posx[1] + 32 < hpos ? 0 : hpos - enemy_posx[1];
  assign x_value_enemy[2] = hpos < enemy_posx[2] || enemy_posx[2] + 32 < hpos ? 0 : hpos - enemy_posx[2];
  assign x_value_enemy[3] = hpos < enemy_posx[3] || enemy_posx[3] + 32 < hpos ? 0 : hpos - enemy_posx[3];
  wire [8:0] y_value_enemy[0:3];
  assign y_value_enemy[0] = vpos < enemy_posy[0] || enemy_posy[0] + 11 < vpos ? 0 : vpos - enemy_posy[0];
  assign y_value_enemy[1] = vpos < enemy_posy[1] || enemy_posy[1] + 11 < vpos ? 0 : vpos - enemy_posy[1];
  assign y_value_enemy[2] = vpos < enemy_posy[2] || enemy_posy[2] + 11 < vpos ? 0 : vpos - enemy_posy[2];
  assign y_value_enemy[3] = vpos < enemy_posy[3] || enemy_posy[3] + 11 < vpos ? 0 : vpos - enemy_posy[3];
  
    
  initial begin
    posx = 123; 
    posy = 200;
    my_res = 0;
    score = 0;
    go_one = 1;
    go_two = -1;
    go_three = 1;
    go_four = -1;
    flag_go = 0;
  end
  
  // по x
  always @(posedge vsync) begin
    if (reset || my_res) begin
      posx <= 123;    
    end else begin 
      if (switches_p1[0] & (posx > 10))
        posx <= posx - 1;
      else begin
        if (switches_p1[1] & (posx < 256 - 10 - size_ship_x))
          posx <= posx + 1;   
      end
    end
  end
  
  // по y
  always @(posedge vsync) begin
    if (reset || my_res) begin
      posy <= 200;
    end else begin 
      if (switches_p1[3] & (posy < 256 - 10 - size_ship_y))
        posy <= posy + 1;
      else begin
        if (switches_p1[2] & (posy > 10))
          posy <= posy - 1;
      end
    end  
  end
  // фон
  always @(posedge vsync) begin
    if (!enemy || reset) begin
      enemy <= 1;
      rad <= {3'b0, clk_value[5:0]};
      enemy_x <= (clk_value) % (236) + 10;
      enemy_y <= rad;
    end else begin
      enemy_y <= enemy_y + 1;
    end
  end
  
  always @(posedge clk) begin
    if (reset)
      clk_value <= 1;
    else begin
      if (clk_value != 256) 
        clk_value <= clk_value + 1;
      else
        clk_value <= 0;
      
    end
  end
  
  // уничтожение врагов
  always @(posedge vsync) begin
    if (my_res || reset) begin
      score <= 0;
      enemy_posy[0] <= clk_value % 20;
      enemy_posy[1] <= clk_value % 50;
      enemy_posy[2] <= clk_value % 10;
      enemy_posy[3] <= clk_value % 40;
    end else begin 
      
      if ((switches_p1[4] && posx + 6 >= enemy_posx[0] && posx + 5 <= enemy_posx[0] + 32) || (enemy_posy[0] == 246)) begin 
        if (!(enemy_posy[0] == 246))
          score <= score + 10;
        enemy_posx[0] <= (clk_value + enemy_posx[3] + enemy_posx[1] + enemy_posx[2]) % 200 + 10;
        enemy_posy[0] <= (clk_value + enemy_posy[3] + enemy_posy[1] + enemy_posy[2]) % 40;
        if (met_col[0] || met_col[1] || met_col[2]) begin
          enemy_posx[0] <= (clk_value + enemy_posx[3] + enemy_posx[1] + enemy_posx[2]) % 200 + 10;
          enemy_posy[0] <= (clk_value + enemy_posy[3] + enemy_posy[1] + enemy_posy[2]) % 40;
        end
      end else begin
        if (enemy_posy[0] != 246) begin 
          enemy_posx[0] <= enemy_posx[0]  + go_one;
          enemy_posy[0] <= enemy_posy[0] + 1;
        end
      end

      if ((switches_p1[4] && posx + 6 >= enemy_posx[1] && posx + 5 <= enemy_posx[1] + 32) || (enemy_posy[1] == 246)) begin 
        if (!(enemy_posy[1] == 246))
          score <= score + 10;
        enemy_posx[1] <= (clk_value + enemy_posx[3] + enemy_posx[0] + enemy_posx[2]) % 200 + 10;
        enemy_posy[1] <= (clk_value + enemy_posy[3] + enemy_posy[0] + enemy_posy[2]) % 40;
        if (met_col[0] || met_col[3] || met_col[4]) begin
          enemy_posx[1] <= (clk_value + enemy_posx[3] + enemy_posx[0] + enemy_posx[2]) % 200 + 10;
          enemy_posy[1] <= (clk_value + enemy_posy[3] + enemy_posy[0] + enemy_posy[2]) % 40;
        end
      end else begin
        if (enemy_posy[1] != 246) begin 
          enemy_posy[1] <= enemy_posy[1] + 1;
          enemy_posx[1] <= enemy_posx[1] + go_two;
        end
      end

      if ((switches_p1[4] && posx + 6 >= enemy_posx[2] && posx + 5 <= enemy_posx[2] + 32) || (enemy_posy[2] == 246)) begin 
        if (!(enemy_posy[2] == 246))
          score <= score + 10;
        enemy_posx[2] <= (clk_value + enemy_posx[3] + enemy_posx[0] + enemy_posx[1]) % 200 + 10;
        enemy_posy[2] <= (clk_value + enemy_posy[3] + enemy_posy[0] + enemy_posy[1]) % 40;
        if (met_col[1] || met_col[3] || met_col[5]) begin
          enemy_posx[2] <= (clk_value + enemy_posx[3] + enemy_posx[0] + enemy_posx[1]) % 200 + 10;
          enemy_posy[2] <= (clk_value + enemy_posy[3] + enemy_posy[0] + enemy_posy[1]) % 40;
        end
      end else begin
        if (enemy_posy[2] != 246) begin 
          enemy_posy[2] <= enemy_posy[2] + 1;
          enemy_posx[2] <= enemy_posx[2] + go_three;
        end
      end

      if ((switches_p1[4] && posx + 6 >= enemy_posx[3] && posx + 5 <= enemy_posx[3] + 32) || (enemy_posy[3] == 246)) begin 
        if (!(enemy_posy[3] == 246))
          score <= score + 10;
        
        enemy_posx[3] <= (clk_value + enemy_posx[0] + enemy_posx[1] + enemy_posx[2]) % 200 + 10;
        enemy_posy[3] <= (clk_value + enemy_posy[0] + enemy_posy[1] + enemy_posy[2]) % 40;
        if (met_col[2] || met_col[4] || met_col[5]) begin 
          enemy_posx[3] <= (clk_value + enemy_posx[0] + enemy_posx[1] + enemy_posx[2]) % 200 + 10;
          enemy_posy[3] <= (clk_value + enemy_posy[0] + enemy_posy[1] + enemy_posy[2]) % 40;
        end
      end else begin
        if (enemy_posy[3] != 246) begin 
          enemy_posy[3] <= enemy_posy[3] + 1;
          enemy_posx[3] <= enemy_posx[3] + go_four;
        end
      end  
    end
  end
  
  always @(posedge flag_go[0]) begin
    go_one <= -go_one;    
  end
  
  always @(posedge flag_go[1]) begin
    go_two <= -go_two;    
  end
  
  always @(posedge flag_go[2]) begin
    go_three <= -go_three;    
  end
  
  always @(posedge flag_go[3]) begin
    go_four <= -go_four;  
  end
  
  assign flag_go[0] = enemy_posx[0] < 10 || enemy_posx[0] > 213 || met_col[0] || met_col[1] || met_col[2];
  assign flag_go[1] = enemy_posx[1] < 10 || enemy_posx[1] > 213 || met_col[0] || met_col[3] || met_col[4];
  assign flag_go[2] = enemy_posx[2] < 10 || enemy_posx[2] > 213 || met_col[1] || met_col[3] || met_col[5];
  assign flag_go[3] = enemy_posx[3] < 10 || enemy_posx[3] > 213 || met_col[2] || met_col[4] || met_col[5];
  
  
  
  // враги
  wire [3:0] meteor;
  reg [8:0] enemy_posx[3:0];
  reg [8:0] enemy_posy[3:0];
  
  reg [8:0] clk_value;
  wire enemy; // фон
  wire [8:0] enemy_y;
  wire [8:0] enemy_x;
  wire [8:0] rad;
  wire flag_enemy = rad * rad== (hpos - enemy_x) * (hpos - enemy_x) + (vpos - enemy_y) * (vpos - enemy_y) && 
  (hpos > 10 && hpos < 246) && (vpos > 10 && vpos < 246);
  wire shot = switches_p1[4] && (hpos == posx + 5 || hpos == posx + 6) && (10 < vpos && vpos < posy);
  wire ship;
  // borders
  wire borders = (hpos == 10  && 10 <= vpos  && vpos <= 246) || (hpos == 246  && 10 <= vpos  && vpos <= 246) ||
                 (vpos == 10  && 10 <= hpos  && hpos <= 246) || (vpos == 246  && 10 <= hpos  && hpos <= 246);
  
  wire r = display_on && (borders || ship || shot || flag_enemy || meteor[0] || meteor[1] || meteor[2] || meteor[3]);
  wire g = display_on && (borders || ship || shot || flag_enemy || meteor[0] || meteor[1] || meteor[2] || meteor[3]);
  wire b = display_on && (borders || ship || meteor[0] || meteor[1] || meteor[2] || meteor[3]);
  assign rgb = {b,g,r};

endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////
module ship_bitmap(x, y, flag);
  input [3:0] x;
  input [3:0] y;
  output flag;

  reg [11:0] bitarray[0:9];
  
  assign flag = bitarray[y][x];
  
  initial begin/*{w:8,h:16}*/
    bitarray[0] = 'b0;
    bitarray[1] = 'b1100000;
    bitarray[2] = 'b11110000;
    bitarray[3] = 'b111111000;
    bitarray[4] = 'b111111000;
    bitarray[5] = 'b111111000;
    bitarray[6] = 'b111111000;
    bitarray[7] = 'b111111000;
    bitarray[8] = 'b11111111110;
    bitarray[9] = 'b11001100110;
  end
  
endmodule

module shot_bitmap(x, y, flag);
  input [3:0] x;
  input [3:0] y;
  output flag;

  reg [4:0] bitarray[0:4];
  
  assign flag = bitarray[y][x];
  
  initial begin/*{w:8,h:16}*/
    bitarray[0] = 'b110;
    bitarray[1] = 'b110;
    bitarray[2] = 'b110;
    bitarray[3] = 'b110;
  end
  
endmodule

module enemy_bitmap(x, y, flag);
  input [4:0] x;
  input [3:0] y;
  output flag;

  reg [31:0] bitarray[0:11];
  reg [8:0] bitarray_two[0:11];
  assign flag = bitarray[y][x];
  
  initial begin/*{w:8,h:16}*/
    bitarray[0]  = 'b00000000000000000000000000000000;
    bitarray[1]  = 'b00000000000111111001100000110000;
    bitarray[2]  = 'b00001111111000000110011111001100;
    bitarray[3]  = 'b00010000000000000000000000000010;
    bitarray[4]  = 'b00100000100000000000000000000010;
    bitarray[5]  = 'b01000001010000000000001000000010;
    bitarray[6]  = 'b00100000100000000000010100000100;
    bitarray[7]  = 'b01000000000000000000001000000010;
    bitarray[8]  = 'b01000000000000000000000000000100;
    bitarray[9]  = 'b01000001100111000110000001111000;
    bitarray[10] = 'b00111110011000111001111110000000;
    bitarray[11] = 'b00000000000000000000000000000000; 
  end
endmodule


 module collider(hpos1, hpos2, vpos1, vpos2, hor_collide, ver_collide);
        input    [8 : 0] hpos1;
        input    [8 : 0] hpos2;
        input    [8 : 0] vpos1;
        input    [8 : 0] vpos2;
        output    hor_collide;
        output    ver_collide;

        parameter hspeed = 0;        // object 1 horizontal speed (to know depth for collision)
        parameter vspeed = 0;        // object 1 vertical speed (to know depth for collision)
        parameter FROM_HSIZE = 0;    // object 1 horizontal size
        parameter FROM_VSIZE = 0;    // object 1 vertical size
        parameter TO_HSIZE = 0;        // object 2 horizontal size
        parameter TO_VSIZE = 0;        // object 2 vertical size

        wire hor_collide_left = hpos1 + FROM_HSIZE >= hpos2 && hpos1 + FROM_HSIZE <= hpos2 + 2 * hspeed;
        wire hor_collide_righ = hpos1 <= hpos2 + TO_HSIZE && hpos1 >= hpos2 + TO_HSIZE - 2 * hspeed; 
        wire hor_collide_nsid = vpos1 >= vpos2 - FROM_VSIZE && vpos1 <= vpos2 + TO_VSIZE;

        wire ver_collide_left = vpos1 + FROM_VSIZE >= vpos2 && vpos1 + FROM_VSIZE < vpos2 + 2 * vspeed;
        wire ver_collide_righ = vpos1 <= vpos2 + TO_VSIZE && vpos1 >= vpos2 + TO_VSIZE - 2 * vspeed; 
        wire ver_collide_nsid = hpos1 >= hpos2 - FROM_HSIZE && hpos1 <= hpos2 + TO_HSIZE;

        assign hor_collide = (hor_collide_left || hor_collide_righ) && hor_collide_nsid;
        assign ver_collide = (ver_collide_left || ver_collide_righ) && ver_collide_nsid;

    endmodule

module collider_v2(hpos1, hpos2, vpos1, vpos2, collide);
        input    [8 : 0] hpos1;
        input    [8 : 0] hpos2;
        input    [8 : 0] vpos1;
        input    [8 : 0] vpos2;
  	output collide;
        wire    hor_collide;
        wire    ver_collide;

        parameter hspeed = 0;        // object 1 horizontal speed (to know depth for collision)
        parameter vspeed = 0;        // object 1 vertical speed (to know depth for collision)
        parameter FROM_HSIZE = 0;    // object 1 horizontal size
        parameter FROM_VSIZE = 0;    // object 1 vertical size
        parameter TO_HSIZE = 0;        // object 2 horizontal size
        parameter TO_VSIZE = 0;        // object 2 vertical size

        wire hor_collide_left = hpos1 + FROM_HSIZE >= hpos2 && hpos1 + FROM_HSIZE <= hpos2 + 2 * hspeed;
        wire hor_collide_righ = hpos1 <= hpos2 + TO_HSIZE && hpos1 >= hpos2 + TO_HSIZE - 2 * hspeed; 
        wire hor_collide_nsid = vpos1 >= vpos2 - FROM_VSIZE && vpos1 <= vpos2 + TO_VSIZE;

        wire ver_collide_left = vpos1 + FROM_VSIZE >= vpos2 && vpos1 + FROM_VSIZE < vpos2 + 2 * vspeed;
        wire ver_collide_righ = vpos1 <= vpos2 + TO_VSIZE && vpos1 >= vpos2 + TO_VSIZE - 2 * vspeed; 
        wire ver_collide_nsid = hpos1 >= hpos2 - FROM_HSIZE && hpos1 <= hpos2 + TO_HSIZE;

        assign hor_collide = (hor_collide_left || hor_collide_righ) && hor_collide_nsid;
        assign ver_collide = (ver_collide_left || ver_collide_righ) && ver_collide_nsid;
	assign collide = hor_collide || ver_collide;
    endmodule