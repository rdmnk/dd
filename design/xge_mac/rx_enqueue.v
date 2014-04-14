 //`include "defines.v"
 
module rx_enqueue(/*AUTOARG*/
  // Outputs
  rxdfifo_wdata, rxdfifo_wstatus, rxdfifo_wen, rxhfifo_ren,
  rxhfifo_wdata, rxhfifo_wstatus, rxhfifo_wen, local_fault_msg_det,
  remote_fault_msg_det, status_crc_error_tog,
  status_fragment_error_tog, status_lenght_error_tog,
  status_rxdfifo_ovflow_tog, status_pause_frame_rx_tog, rxsfifo_wen,
  rxsfifo_wdata,
  // Inputs
  clk_xgmii_rx, reset_xgmii_rx_n, xgmii_rxd, xgmii_rxc, rxdfifo_wfull,
  rxhfifo_rdata, rxhfifo_rstatus, rxhfifo_rempty,
  rxhfifo_ralmost_empty
  );
 
//`include "CRC32_D64.v"
//`include "CRC32_D8.v"
 //`include "utils.v"
 
input         clk_xgmii_rx;
input         reset_xgmii_rx_n;
 
input  [63:0] xgmii_rxd;
input  [7:0]  xgmii_rxc;
 
input         rxdfifo_wfull;
 
input  [63:0] rxhfifo_rdata;
input  [7:0]  rxhfifo_rstatus;
input         rxhfifo_rempty;
input         rxhfifo_ralmost_empty;
 
output [63:0] rxdfifo_wdata;
output [7:0]  rxdfifo_wstatus;
output        rxdfifo_wen;
 
output        rxhfifo_ren;
 
output [63:0] rxhfifo_wdata;
output [7:0]  rxhfifo_wstatus;
output        rxhfifo_wen;
 
output [1:0]  local_fault_msg_det;
output [1:0]  remote_fault_msg_det;
 
output        status_crc_error_tog;
output        status_fragment_error_tog;
output        status_lenght_error_tog;
output        status_rxdfifo_ovflow_tog;
 
output        status_pause_frame_rx_tog;
 
output        rxsfifo_wen;
output [13:0] rxsfifo_wdata;
 
 function [31:0] nextCRC32_D8;
 
    input [7:0] Data;
    input [31:0] CRC;
 
    reg [7:0] D;
    reg [31:0] C;
    reg [31:0] NewCRC;
 
  begin
 
    D = Data;
    C = CRC;
 
    NewCRC[0] = D[6] ^ D[0] ^ C[24] ^ C[30];
    NewCRC[1] = D[7] ^ D[6] ^ D[1] ^ D[0] ^ C[24] ^ C[25] ^ C[30] ^ 
                C[31];
    NewCRC[2] = D[7] ^ D[6] ^ D[2] ^ D[1] ^ D[0] ^ C[24] ^ C[25] ^ 
                C[26] ^ C[30] ^ C[31];
    NewCRC[3] = D[7] ^ D[3] ^ D[2] ^ D[1] ^ C[25] ^ C[26] ^ C[27] ^ 
                C[31];
    NewCRC[4] = D[6] ^ D[4] ^ D[3] ^ D[2] ^ D[0] ^ C[24] ^ C[26] ^ 
                C[27] ^ C[28] ^ C[30];
    NewCRC[5] = D[7] ^ D[6] ^ D[5] ^ D[4] ^ D[3] ^ D[1] ^ D[0] ^ C[24] ^ 
                C[25] ^ C[27] ^ C[28] ^ C[29] ^ C[30] ^ C[31];
    NewCRC[6] = D[7] ^ D[6] ^ D[5] ^ D[4] ^ D[2] ^ D[1] ^ C[25] ^ C[26] ^ 
                C[28] ^ C[29] ^ C[30] ^ C[31];
    NewCRC[7] = D[7] ^ D[5] ^ D[3] ^ D[2] ^ D[0] ^ C[24] ^ C[26] ^ 
                C[27] ^ C[29] ^ C[31];
    NewCRC[8] = D[4] ^ D[3] ^ D[1] ^ D[0] ^ C[0] ^ C[24] ^ C[25] ^ 
                C[27] ^ C[28];
    NewCRC[9] = D[5] ^ D[4] ^ D[2] ^ D[1] ^ C[1] ^ C[25] ^ C[26] ^ 
                C[28] ^ C[29];
    NewCRC[10] = D[5] ^ D[3] ^ D[2] ^ D[0] ^ C[2] ^ C[24] ^ C[26] ^ 
                 C[27] ^ C[29];
    NewCRC[11] = D[4] ^ D[3] ^ D[1] ^ D[0] ^ C[3] ^ C[24] ^ C[25] ^ 
                 C[27] ^ C[28];
    NewCRC[12] = D[6] ^ D[5] ^ D[4] ^ D[2] ^ D[1] ^ D[0] ^ C[4] ^ C[24] ^ 
                 C[25] ^ C[26] ^ C[28] ^ C[29] ^ C[30];
    NewCRC[13] = D[7] ^ D[6] ^ D[5] ^ D[3] ^ D[2] ^ D[1] ^ C[5] ^ C[25] ^ 
                 C[26] ^ C[27] ^ C[29] ^ C[30] ^ C[31];
    NewCRC[14] = D[7] ^ D[6] ^ D[4] ^ D[3] ^ D[2] ^ C[6] ^ C[26] ^ C[27] ^ 
                 C[28] ^ C[30] ^ C[31];
    NewCRC[15] = D[7] ^ D[5] ^ D[4] ^ D[3] ^ C[7] ^ C[27] ^ C[28] ^ 
                 C[29] ^ C[31];
    NewCRC[16] = D[5] ^ D[4] ^ D[0] ^ C[8] ^ C[24] ^ C[28] ^ C[29];
    NewCRC[17] = D[6] ^ D[5] ^ D[1] ^ C[9] ^ C[25] ^ C[29] ^ C[30];
    NewCRC[18] = D[7] ^ D[6] ^ D[2] ^ C[10] ^ C[26] ^ C[30] ^ C[31];
    NewCRC[19] = D[7] ^ D[3] ^ C[11] ^ C[27] ^ C[31];
    NewCRC[20] = D[4] ^ C[12] ^ C[28];
    NewCRC[21] = D[5] ^ C[13] ^ C[29];
    NewCRC[22] = D[0] ^ C[14] ^ C[24];
    NewCRC[23] = D[6] ^ D[1] ^ D[0] ^ C[15] ^ C[24] ^ C[25] ^ C[30];
    NewCRC[24] = D[7] ^ D[2] ^ D[1] ^ C[16] ^ C[25] ^ C[26] ^ C[31];
    NewCRC[25] = D[3] ^ D[2] ^ C[17] ^ C[26] ^ C[27];
    NewCRC[26] = D[6] ^ D[4] ^ D[3] ^ D[0] ^ C[18] ^ C[24] ^ C[27] ^ 
                 C[28] ^ C[30];
    NewCRC[27] = D[7] ^ D[5] ^ D[4] ^ D[1] ^ C[19] ^ C[25] ^ C[28] ^ 
                 C[29] ^ C[31];
    NewCRC[28] = D[6] ^ D[5] ^ D[2] ^ C[20] ^ C[26] ^ C[29] ^ C[30];
    NewCRC[29] = D[7] ^ D[6] ^ D[3] ^ C[21] ^ C[27] ^ C[30] ^ C[31];
    NewCRC[30] = D[7] ^ D[4] ^ C[22] ^ C[28] ^ C[31];
    NewCRC[31] = D[5] ^ C[23] ^ C[29];
 
    nextCRC32_D8 = NewCRC;
 
  end
 
  endfunction
  
  function [31:0] nextCRC32_D64;
 
    input [63:0] Data;
    input [31:0] CRC;
 
    reg [63:0] D;
    reg [31:0] C;
    reg [31:0] NewCRC;
 
  begin
 
    D = Data;
    C = CRC;
 
    NewCRC[0] = D[63] ^ D[61] ^ D[60] ^ D[58] ^ D[55] ^ D[54] ^ D[53] ^ 
                D[50] ^ D[48] ^ D[47] ^ D[45] ^ D[44] ^ D[37] ^ D[34] ^ 
                D[32] ^ D[31] ^ D[30] ^ D[29] ^ D[28] ^ D[26] ^ D[25] ^ 
                D[24] ^ D[16] ^ D[12] ^ D[10] ^ D[9] ^ D[6] ^ D[0] ^ 
                C[0] ^ C[2] ^ C[5] ^ C[12] ^ C[13] ^ C[15] ^ C[16] ^ 
                C[18] ^ C[21] ^ C[22] ^ C[23] ^ C[26] ^ C[28] ^ C[29] ^ 
                C[31];
    NewCRC[1] = D[63] ^ D[62] ^ D[60] ^ D[59] ^ D[58] ^ D[56] ^ D[53] ^ 
                D[51] ^ D[50] ^ D[49] ^ D[47] ^ D[46] ^ D[44] ^ D[38] ^ 
                D[37] ^ D[35] ^ D[34] ^ D[33] ^ D[28] ^ D[27] ^ D[24] ^ 
                D[17] ^ D[16] ^ D[13] ^ D[12] ^ D[11] ^ D[9] ^ D[7] ^ 
                D[6] ^ D[1] ^ D[0] ^ C[1] ^ C[2] ^ C[3] ^ C[5] ^ C[6] ^ 
                C[12] ^ C[14] ^ C[15] ^ C[17] ^ C[18] ^ C[19] ^ C[21] ^ 
                C[24] ^ C[26] ^ C[27] ^ C[28] ^ C[30] ^ C[31];
    NewCRC[2] = D[59] ^ D[58] ^ D[57] ^ D[55] ^ D[53] ^ D[52] ^ D[51] ^ 
                D[44] ^ D[39] ^ D[38] ^ D[37] ^ D[36] ^ D[35] ^ D[32] ^ 
                D[31] ^ D[30] ^ D[26] ^ D[24] ^ D[18] ^ D[17] ^ D[16] ^ 
                D[14] ^ D[13] ^ D[9] ^ D[8] ^ D[7] ^ D[6] ^ D[2] ^ 
                D[1] ^ D[0] ^ C[0] ^ C[3] ^ C[4] ^ C[5] ^ C[6] ^ C[7] ^ 
                C[12] ^ C[19] ^ C[20] ^ C[21] ^ C[23] ^ C[25] ^ C[26] ^ 
                C[27];
    NewCRC[3] = D[60] ^ D[59] ^ D[58] ^ D[56] ^ D[54] ^ D[53] ^ D[52] ^ 
                D[45] ^ D[40] ^ D[39] ^ D[38] ^ D[37] ^ D[36] ^ D[33] ^ 
                D[32] ^ D[31] ^ D[27] ^ D[25] ^ D[19] ^ D[18] ^ D[17] ^ 
                D[15] ^ D[14] ^ D[10] ^ D[9] ^ D[8] ^ D[7] ^ D[3] ^ 
                D[2] ^ D[1] ^ C[0] ^ C[1] ^ C[4] ^ C[5] ^ C[6] ^ C[7] ^ 
                C[8] ^ C[13] ^ C[20] ^ C[21] ^ C[22] ^ C[24] ^ C[26] ^ 
                C[27] ^ C[28];
    NewCRC[4] = D[63] ^ D[59] ^ D[58] ^ D[57] ^ D[50] ^ D[48] ^ D[47] ^ 
                D[46] ^ D[45] ^ D[44] ^ D[41] ^ D[40] ^ D[39] ^ D[38] ^ 
                D[33] ^ D[31] ^ D[30] ^ D[29] ^ D[25] ^ D[24] ^ D[20] ^ 
                D[19] ^ D[18] ^ D[15] ^ D[12] ^ D[11] ^ D[8] ^ D[6] ^ 
                D[4] ^ D[3] ^ D[2] ^ D[0] ^ C[1] ^ C[6] ^ C[7] ^ C[8] ^ 
                C[9] ^ C[12] ^ C[13] ^ C[14] ^ C[15] ^ C[16] ^ C[18] ^ 
                C[25] ^ C[26] ^ C[27] ^ C[31];
    NewCRC[5] = D[63] ^ D[61] ^ D[59] ^ D[55] ^ D[54] ^ D[53] ^ D[51] ^ 
                D[50] ^ D[49] ^ D[46] ^ D[44] ^ D[42] ^ D[41] ^ D[40] ^ 
                D[39] ^ D[37] ^ D[29] ^ D[28] ^ D[24] ^ D[21] ^ D[20] ^ 
                D[19] ^ D[13] ^ D[10] ^ D[7] ^ D[6] ^ D[5] ^ D[4] ^ 
                D[3] ^ D[1] ^ D[0] ^ C[5] ^ C[7] ^ C[8] ^ C[9] ^ C[10] ^ 
                C[12] ^ C[14] ^ C[17] ^ C[18] ^ C[19] ^ C[21] ^ C[22] ^ 
                C[23] ^ C[27] ^ C[29] ^ C[31];
    NewCRC[6] = D[62] ^ D[60] ^ D[56] ^ D[55] ^ D[54] ^ D[52] ^ D[51] ^ 
                D[50] ^ D[47] ^ D[45] ^ D[43] ^ D[42] ^ D[41] ^ D[40] ^ 
                D[38] ^ D[30] ^ D[29] ^ D[25] ^ D[22] ^ D[21] ^ D[20] ^ 
                D[14] ^ D[11] ^ D[8] ^ D[7] ^ D[6] ^ D[5] ^ D[4] ^ 
                D[2] ^ D[1] ^ C[6] ^ C[8] ^ C[9] ^ C[10] ^ C[11] ^ 
                C[13] ^ C[15] ^ C[18] ^ C[19] ^ C[20] ^ C[22] ^ C[23] ^ 
                C[24] ^ C[28] ^ C[30];
    NewCRC[7] = D[60] ^ D[58] ^ D[57] ^ D[56] ^ D[54] ^ D[52] ^ D[51] ^ 
                D[50] ^ D[47] ^ D[46] ^ D[45] ^ D[43] ^ D[42] ^ D[41] ^ 
                D[39] ^ D[37] ^ D[34] ^ D[32] ^ D[29] ^ D[28] ^ D[25] ^ 
                D[24] ^ D[23] ^ D[22] ^ D[21] ^ D[16] ^ D[15] ^ D[10] ^ 
                D[8] ^ D[7] ^ D[5] ^ D[3] ^ D[2] ^ D[0] ^ C[0] ^ C[2] ^ 
                C[5] ^ C[7] ^ C[9] ^ C[10] ^ C[11] ^ C[13] ^ C[14] ^ 
                C[15] ^ C[18] ^ C[19] ^ C[20] ^ C[22] ^ C[24] ^ C[25] ^ 
                C[26] ^ C[28];
    NewCRC[8] = D[63] ^ D[60] ^ D[59] ^ D[57] ^ D[54] ^ D[52] ^ D[51] ^ 
                D[50] ^ D[46] ^ D[45] ^ D[43] ^ D[42] ^ D[40] ^ D[38] ^ 
                D[37] ^ D[35] ^ D[34] ^ D[33] ^ D[32] ^ D[31] ^ D[28] ^ 
                D[23] ^ D[22] ^ D[17] ^ D[12] ^ D[11] ^ D[10] ^ D[8] ^ 
                D[4] ^ D[3] ^ D[1] ^ D[0] ^ C[0] ^ C[1] ^ C[2] ^ C[3] ^ 
                C[5] ^ C[6] ^ C[8] ^ C[10] ^ C[11] ^ C[13] ^ C[14] ^ 
                C[18] ^ C[19] ^ C[20] ^ C[22] ^ C[25] ^ C[27] ^ C[28] ^ 
                C[31];
    NewCRC[9] = D[61] ^ D[60] ^ D[58] ^ D[55] ^ D[53] ^ D[52] ^ D[51] ^ 
                D[47] ^ D[46] ^ D[44] ^ D[43] ^ D[41] ^ D[39] ^ D[38] ^ 
                D[36] ^ D[35] ^ D[34] ^ D[33] ^ D[32] ^ D[29] ^ D[24] ^ 
                D[23] ^ D[18] ^ D[13] ^ D[12] ^ D[11] ^ D[9] ^ D[5] ^ 
                D[4] ^ D[2] ^ D[1] ^ C[0] ^ C[1] ^ C[2] ^ C[3] ^ C[4] ^ 
                C[6] ^ C[7] ^ C[9] ^ C[11] ^ C[12] ^ C[14] ^ C[15] ^ 
                C[19] ^ C[20] ^ C[21] ^ C[23] ^ C[26] ^ C[28] ^ C[29];
    NewCRC[10] = D[63] ^ D[62] ^ D[60] ^ D[59] ^ D[58] ^ D[56] ^ D[55] ^ 
                 D[52] ^ D[50] ^ D[42] ^ D[40] ^ D[39] ^ D[36] ^ D[35] ^ 
                 D[33] ^ D[32] ^ D[31] ^ D[29] ^ D[28] ^ D[26] ^ D[19] ^ 
                 D[16] ^ D[14] ^ D[13] ^ D[9] ^ D[5] ^ D[3] ^ D[2] ^ 
                 D[0] ^ C[0] ^ C[1] ^ C[3] ^ C[4] ^ C[7] ^ C[8] ^ C[10] ^ 
                 C[18] ^ C[20] ^ C[23] ^ C[24] ^ C[26] ^ C[27] ^ C[28] ^ 
                 C[30] ^ C[31];
    NewCRC[11] = D[59] ^ D[58] ^ D[57] ^ D[56] ^ D[55] ^ D[54] ^ D[51] ^ 
                 D[50] ^ D[48] ^ D[47] ^ D[45] ^ D[44] ^ D[43] ^ D[41] ^ 
                 D[40] ^ D[36] ^ D[33] ^ D[31] ^ D[28] ^ D[27] ^ D[26] ^ 
                 D[25] ^ D[24] ^ D[20] ^ D[17] ^ D[16] ^ D[15] ^ D[14] ^ 
                 D[12] ^ D[9] ^ D[4] ^ D[3] ^ D[1] ^ D[0] ^ C[1] ^ C[4] ^ 
                 C[8] ^ C[9] ^ C[11] ^ C[12] ^ C[13] ^ C[15] ^ C[16] ^ 
                 C[18] ^ C[19] ^ C[22] ^ C[23] ^ C[24] ^ C[25] ^ C[26] ^ 
                 C[27];
    NewCRC[12] = D[63] ^ D[61] ^ D[59] ^ D[57] ^ D[56] ^ D[54] ^ D[53] ^ 
                 D[52] ^ D[51] ^ D[50] ^ D[49] ^ D[47] ^ D[46] ^ D[42] ^ 
                 D[41] ^ D[31] ^ D[30] ^ D[27] ^ D[24] ^ D[21] ^ D[18] ^ 
                 D[17] ^ D[15] ^ D[13] ^ D[12] ^ D[9] ^ D[6] ^ D[5] ^ 
                 D[4] ^ D[2] ^ D[1] ^ D[0] ^ C[9] ^ C[10] ^ C[14] ^ 
                 C[15] ^ C[17] ^ C[18] ^ C[19] ^ C[20] ^ C[21] ^ C[22] ^ 
                 C[24] ^ C[25] ^ C[27] ^ C[29] ^ C[31];
    NewCRC[13] = D[62] ^ D[60] ^ D[58] ^ D[57] ^ D[55] ^ D[54] ^ D[53] ^ 
                 D[52] ^ D[51] ^ D[50] ^ D[48] ^ D[47] ^ D[43] ^ D[42] ^ 
                 D[32] ^ D[31] ^ D[28] ^ D[25] ^ D[22] ^ D[19] ^ D[18] ^ 
                 D[16] ^ D[14] ^ D[13] ^ D[10] ^ D[7] ^ D[6] ^ D[5] ^ 
                 D[3] ^ D[2] ^ D[1] ^ C[0] ^ C[10] ^ C[11] ^ C[15] ^ 
                 C[16] ^ C[18] ^ C[19] ^ C[20] ^ C[21] ^ C[22] ^ C[23] ^ 
                 C[25] ^ C[26] ^ C[28] ^ C[30];
    NewCRC[14] = D[63] ^ D[61] ^ D[59] ^ D[58] ^ D[56] ^ D[55] ^ D[54] ^ 
                 D[53] ^ D[52] ^ D[51] ^ D[49] ^ D[48] ^ D[44] ^ D[43] ^ 
                 D[33] ^ D[32] ^ D[29] ^ D[26] ^ D[23] ^ D[20] ^ D[19] ^ 
                 D[17] ^ D[15] ^ D[14] ^ D[11] ^ D[8] ^ D[7] ^ D[6] ^ 
                 D[4] ^ D[3] ^ D[2] ^ C[0] ^ C[1] ^ C[11] ^ C[12] ^ 
                 C[16] ^ C[17] ^ C[19] ^ C[20] ^ C[21] ^ C[22] ^ C[23] ^ 
                 C[24] ^ C[26] ^ C[27] ^ C[29] ^ C[31];
    NewCRC[15] = D[62] ^ D[60] ^ D[59] ^ D[57] ^ D[56] ^ D[55] ^ D[54] ^ 
                 D[53] ^ D[52] ^ D[50] ^ D[49] ^ D[45] ^ D[44] ^ D[34] ^ 
                 D[33] ^ D[30] ^ D[27] ^ D[24] ^ D[21] ^ D[20] ^ D[18] ^ 
                 D[16] ^ D[15] ^ D[12] ^ D[9] ^ D[8] ^ D[7] ^ D[5] ^ 
                 D[4] ^ D[3] ^ C[1] ^ C[2] ^ C[12] ^ C[13] ^ C[17] ^ 
                 C[18] ^ C[20] ^ C[21] ^ C[22] ^ C[23] ^ C[24] ^ C[25] ^ 
                 C[27] ^ C[28] ^ C[30];
    NewCRC[16] = D[57] ^ D[56] ^ D[51] ^ D[48] ^ D[47] ^ D[46] ^ D[44] ^ 
                 D[37] ^ D[35] ^ D[32] ^ D[30] ^ D[29] ^ D[26] ^ D[24] ^ 
                 D[22] ^ D[21] ^ D[19] ^ D[17] ^ D[13] ^ D[12] ^ D[8] ^ 
                 D[5] ^ D[4] ^ D[0] ^ C[0] ^ C[3] ^ C[5] ^ C[12] ^ C[14] ^ 
                 C[15] ^ C[16] ^ C[19] ^ C[24] ^ C[25];
    NewCRC[17] = D[58] ^ D[57] ^ D[52] ^ D[49] ^ D[48] ^ D[47] ^ D[45] ^ 
                 D[38] ^ D[36] ^ D[33] ^ D[31] ^ D[30] ^ D[27] ^ D[25] ^ 
                 D[23] ^ D[22] ^ D[20] ^ D[18] ^ D[14] ^ D[13] ^ D[9] ^ 
                 D[6] ^ D[5] ^ D[1] ^ C[1] ^ C[4] ^ C[6] ^ C[13] ^ C[15] ^ 
                 C[16] ^ C[17] ^ C[20] ^ C[25] ^ C[26];
    NewCRC[18] = D[59] ^ D[58] ^ D[53] ^ D[50] ^ D[49] ^ D[48] ^ D[46] ^ 
                 D[39] ^ D[37] ^ D[34] ^ D[32] ^ D[31] ^ D[28] ^ D[26] ^ 
                 D[24] ^ D[23] ^ D[21] ^ D[19] ^ D[15] ^ D[14] ^ D[10] ^ 
                 D[7] ^ D[6] ^ D[2] ^ C[0] ^ C[2] ^ C[5] ^ C[7] ^ C[14] ^ 
                 C[16] ^ C[17] ^ C[18] ^ C[21] ^ C[26] ^ C[27];
    NewCRC[19] = D[60] ^ D[59] ^ D[54] ^ D[51] ^ D[50] ^ D[49] ^ D[47] ^ 
                 D[40] ^ D[38] ^ D[35] ^ D[33] ^ D[32] ^ D[29] ^ D[27] ^ 
                 D[25] ^ D[24] ^ D[22] ^ D[20] ^ D[16] ^ D[15] ^ D[11] ^ 
                 D[8] ^ D[7] ^ D[3] ^ C[0] ^ C[1] ^ C[3] ^ C[6] ^ C[8] ^ 
                 C[15] ^ C[17] ^ C[18] ^ C[19] ^ C[22] ^ C[27] ^ C[28];
    NewCRC[20] = D[61] ^ D[60] ^ D[55] ^ D[52] ^ D[51] ^ D[50] ^ D[48] ^ 
                 D[41] ^ D[39] ^ D[36] ^ D[34] ^ D[33] ^ D[30] ^ D[28] ^ 
                 D[26] ^ D[25] ^ D[23] ^ D[21] ^ D[17] ^ D[16] ^ D[12] ^ 
                 D[9] ^ D[8] ^ D[4] ^ C[1] ^ C[2] ^ C[4] ^ C[7] ^ C[9] ^ 
                 C[16] ^ C[18] ^ C[19] ^ C[20] ^ C[23] ^ C[28] ^ C[29];
    NewCRC[21] = D[62] ^ D[61] ^ D[56] ^ D[53] ^ D[52] ^ D[51] ^ D[49] ^ 
                 D[42] ^ D[40] ^ D[37] ^ D[35] ^ D[34] ^ D[31] ^ D[29] ^ 
                 D[27] ^ D[26] ^ D[24] ^ D[22] ^ D[18] ^ D[17] ^ D[13] ^ 
                 D[10] ^ D[9] ^ D[5] ^ C[2] ^ C[3] ^ C[5] ^ C[8] ^ C[10] ^ 
                 C[17] ^ C[19] ^ C[20] ^ C[21] ^ C[24] ^ C[29] ^ C[30];
    NewCRC[22] = D[62] ^ D[61] ^ D[60] ^ D[58] ^ D[57] ^ D[55] ^ D[52] ^ 
                 D[48] ^ D[47] ^ D[45] ^ D[44] ^ D[43] ^ D[41] ^ D[38] ^ 
                 D[37] ^ D[36] ^ D[35] ^ D[34] ^ D[31] ^ D[29] ^ D[27] ^ 
                 D[26] ^ D[24] ^ D[23] ^ D[19] ^ D[18] ^ D[16] ^ D[14] ^ 
                 D[12] ^ D[11] ^ D[9] ^ D[0] ^ C[2] ^ C[3] ^ C[4] ^ 
                 C[5] ^ C[6] ^ C[9] ^ C[11] ^ C[12] ^ C[13] ^ C[15] ^ 
                 C[16] ^ C[20] ^ C[23] ^ C[25] ^ C[26] ^ C[28] ^ C[29] ^ 
                 C[30];
    NewCRC[23] = D[62] ^ D[60] ^ D[59] ^ D[56] ^ D[55] ^ D[54] ^ D[50] ^ 
                 D[49] ^ D[47] ^ D[46] ^ D[42] ^ D[39] ^ D[38] ^ D[36] ^ 
                 D[35] ^ D[34] ^ D[31] ^ D[29] ^ D[27] ^ D[26] ^ D[20] ^ 
                 D[19] ^ D[17] ^ D[16] ^ D[15] ^ D[13] ^ D[9] ^ D[6] ^ 
                 D[1] ^ D[0] ^ C[2] ^ C[3] ^ C[4] ^ C[6] ^ C[7] ^ C[10] ^ 
                 C[14] ^ C[15] ^ C[17] ^ C[18] ^ C[22] ^ C[23] ^ C[24] ^ 
                 C[27] ^ C[28] ^ C[30];
    NewCRC[24] = D[63] ^ D[61] ^ D[60] ^ D[57] ^ D[56] ^ D[55] ^ D[51] ^ 
                 D[50] ^ D[48] ^ D[47] ^ D[43] ^ D[40] ^ D[39] ^ D[37] ^ 
                 D[36] ^ D[35] ^ D[32] ^ D[30] ^ D[28] ^ D[27] ^ D[21] ^ 
                 D[20] ^ D[18] ^ D[17] ^ D[16] ^ D[14] ^ D[10] ^ D[7] ^ 
                 D[2] ^ D[1] ^ C[0] ^ C[3] ^ C[4] ^ C[5] ^ C[7] ^ C[8] ^ 
                 C[11] ^ C[15] ^ C[16] ^ C[18] ^ C[19] ^ C[23] ^ C[24] ^ 
                 C[25] ^ C[28] ^ C[29] ^ C[31];
    NewCRC[25] = D[62] ^ D[61] ^ D[58] ^ D[57] ^ D[56] ^ D[52] ^ D[51] ^ 
                 D[49] ^ D[48] ^ D[44] ^ D[41] ^ D[40] ^ D[38] ^ D[37] ^ 
                 D[36] ^ D[33] ^ D[31] ^ D[29] ^ D[28] ^ D[22] ^ D[21] ^ 
                 D[19] ^ D[18] ^ D[17] ^ D[15] ^ D[11] ^ D[8] ^ D[3] ^ 
                 D[2] ^ C[1] ^ C[4] ^ C[5] ^ C[6] ^ C[8] ^ C[9] ^ C[12] ^ 
                 C[16] ^ C[17] ^ C[19] ^ C[20] ^ C[24] ^ C[25] ^ C[26] ^ 
                 C[29] ^ C[30];
    NewCRC[26] = D[62] ^ D[61] ^ D[60] ^ D[59] ^ D[57] ^ D[55] ^ D[54] ^ 
                 D[52] ^ D[49] ^ D[48] ^ D[47] ^ D[44] ^ D[42] ^ D[41] ^ 
                 D[39] ^ D[38] ^ D[31] ^ D[28] ^ D[26] ^ D[25] ^ D[24] ^ 
                 D[23] ^ D[22] ^ D[20] ^ D[19] ^ D[18] ^ D[10] ^ D[6] ^ 
                 D[4] ^ D[3] ^ D[0] ^ C[6] ^ C[7] ^ C[9] ^ C[10] ^ C[12] ^ 
                 C[15] ^ C[16] ^ C[17] ^ C[20] ^ C[22] ^ C[23] ^ C[25] ^ 
                 C[27] ^ C[28] ^ C[29] ^ C[30];
    NewCRC[27] = D[63] ^ D[62] ^ D[61] ^ D[60] ^ D[58] ^ D[56] ^ D[55] ^ 
                 D[53] ^ D[50] ^ D[49] ^ D[48] ^ D[45] ^ D[43] ^ D[42] ^ 
                 D[40] ^ D[39] ^ D[32] ^ D[29] ^ D[27] ^ D[26] ^ D[25] ^ 
                 D[24] ^ D[23] ^ D[21] ^ D[20] ^ D[19] ^ D[11] ^ D[7] ^ 
                 D[5] ^ D[4] ^ D[1] ^ C[0] ^ C[7] ^ C[8] ^ C[10] ^ C[11] ^ 
                 C[13] ^ C[16] ^ C[17] ^ C[18] ^ C[21] ^ C[23] ^ C[24] ^ 
                 C[26] ^ C[28] ^ C[29] ^ C[30] ^ C[31];
    NewCRC[28] = D[63] ^ D[62] ^ D[61] ^ D[59] ^ D[57] ^ D[56] ^ D[54] ^ 
                 D[51] ^ D[50] ^ D[49] ^ D[46] ^ D[44] ^ D[43] ^ D[41] ^ 
                 D[40] ^ D[33] ^ D[30] ^ D[28] ^ D[27] ^ D[26] ^ D[25] ^ 
                 D[24] ^ D[22] ^ D[21] ^ D[20] ^ D[12] ^ D[8] ^ D[6] ^ 
                 D[5] ^ D[2] ^ C[1] ^ C[8] ^ C[9] ^ C[11] ^ C[12] ^ 
                 C[14] ^ C[17] ^ C[18] ^ C[19] ^ C[22] ^ C[24] ^ C[25] ^ 
                 C[27] ^ C[29] ^ C[30] ^ C[31];
    NewCRC[29] = D[63] ^ D[62] ^ D[60] ^ D[58] ^ D[57] ^ D[55] ^ D[52] ^ 
                 D[51] ^ D[50] ^ D[47] ^ D[45] ^ D[44] ^ D[42] ^ D[41] ^ 
                 D[34] ^ D[31] ^ D[29] ^ D[28] ^ D[27] ^ D[26] ^ D[25] ^ 
                 D[23] ^ D[22] ^ D[21] ^ D[13] ^ D[9] ^ D[7] ^ D[6] ^ 
                 D[3] ^ C[2] ^ C[9] ^ C[10] ^ C[12] ^ C[13] ^ C[15] ^ 
                 C[18] ^ C[19] ^ C[20] ^ C[23] ^ C[25] ^ C[26] ^ C[28] ^ 
                 C[30] ^ C[31];
    NewCRC[30] = D[63] ^ D[61] ^ D[59] ^ D[58] ^ D[56] ^ D[53] ^ D[52] ^ 
                 D[51] ^ D[48] ^ D[46] ^ D[45] ^ D[43] ^ D[42] ^ D[35] ^ 
                 D[32] ^ D[30] ^ D[29] ^ D[28] ^ D[27] ^ D[26] ^ D[24] ^ 
                 D[23] ^ D[22] ^ D[14] ^ D[10] ^ D[8] ^ D[7] ^ D[4] ^ 
                 C[0] ^ C[3] ^ C[10] ^ C[11] ^ C[13] ^ C[14] ^ C[16] ^ 
                 C[19] ^ C[20] ^ C[21] ^ C[24] ^ C[26] ^ C[27] ^ C[29] ^ 
                 C[31];
    NewCRC[31] = D[62] ^ D[60] ^ D[59] ^ D[57] ^ D[54] ^ D[53] ^ D[52] ^ 
                 D[49] ^ D[47] ^ D[46] ^ D[44] ^ D[43] ^ D[36] ^ D[33] ^ 
                 D[31] ^ D[30] ^ D[29] ^ D[28] ^ D[27] ^ D[25] ^ D[24] ^ 
                 D[23] ^ D[15] ^ D[11] ^ D[9] ^ D[8] ^ D[5] ^ C[1] ^ 
                 C[4] ^ C[11] ^ C[12] ^ C[14] ^ C[15] ^ C[17] ^ C[20] ^ 
                 C[21] ^ C[22] ^ C[25] ^ C[27] ^ C[28] ^ C[30];
 
    nextCRC32_D64 = NewCRC;
 
  end
 
  endfunction
  
  function [63:0] reverse_64b;
  input [63:0]   data;
  integer        i;
    begin
        for (i = 0; i < 64; i = i + 1) begin
            reverse_64b[i] = data[63 - i];
        end
    end
endfunction
 
 
function [31:0] reverse_32b;
  input [31:0]   data;
  integer        i;
    begin
        for (i = 0; i < 32; i = i + 1) begin
            reverse_32b[i] = data[31 - i];
        end
    end
endfunction
 
 
function [7:0] reverse_8b;
  input [7:0]   data;
  integer        i;
    begin
        for (i = 0; i < 8; i = i + 1) begin
            reverse_8b[i] = data[7 - i];
        end
    end
endfunction
 
/*AUTOREG*/
// Beginning of automatic regs (for this module's undeclared outputs)
reg [1:0]               local_fault_msg_det;
reg [1:0]               remote_fault_msg_det;
reg [63:0]              rxdfifo_wdata;
reg                     rxdfifo_wen;
reg [7:0]               rxdfifo_wstatus;
reg                     rxhfifo_ren;
reg [63:0]              rxhfifo_wdata;
reg                     rxhfifo_wen;
reg [7:0]               rxhfifo_wstatus;
reg [13:0]              rxsfifo_wdata;
reg                     rxsfifo_wen;
reg                     status_crc_error_tog;
reg                     status_fragment_error_tog;
reg                     status_lenght_error_tog;
reg                     status_pause_frame_rx_tog;
reg                     status_rxdfifo_ovflow_tog;
// End of automatics
 
/*AUTOWIRE*/
 
 
reg [63:32]   xgmii_rxd_d1;
reg [7:4]     xgmii_rxc_d1;
 
reg [63:0]    xgxs_rxd_barrel;
reg [7:0]     xgxs_rxc_barrel;
 
reg [63:0]    xgxs_rxd_barrel_d1;
reg [7:0]     xgxs_rxc_barrel_d1;
 
reg           barrel_shift;
 
reg [31:0]    crc32_d64;
reg [31:0]    crc32_d8;
 
reg [3:0]     crc_bytes;
reg [3:0]     next_crc_bytes;
 
reg [63:0]    crc_shift_data;
reg           crc_start_8b;
reg           crc_done;
reg	      crc_good;
reg           crc_clear;
 
reg [31:0]    crc_rx;
reg [31:0]    next_crc_rx;
 
reg [2:0]     curr_state;
reg [2:0]     next_state;
 
reg [13:0]    curr_byte_cnt;
reg [13:0]    next_byte_cnt;
reg [13:0]    frame_lenght;
 
reg           frame_end_flag;
reg           next_frame_end_flag;
 
reg [2:0]     frame_end_bytes;
reg [2:0]     next_frame_end_bytes;
 
reg           fragment_error;
reg           rxd_ovflow_error;
 
reg           lenght_error;
 
reg           coding_error;
reg           next_coding_error;
 
reg [7:0]     addmask;
reg [7:0]     datamask;
 
reg           pause_frame;
reg           next_pause_frame;
reg           pause_frame_hold;
 
reg           good_pause_frame;
 
reg           drop_data;
reg           next_drop_data;
 
reg           pkt_pending;
 
reg           rxhfifo_ren_d1;
 
reg           rxhfifo_ralmost_empty_d1;
 
 
parameter [2:0]
             SM_IDLE = 3'd0,
             SM_RX = 3'd1;
 
// count the number of set bits in a nibble
function [2:0] bit_cnt4;
input   [3:0]   bits;
    begin
    case (bits)
    0:  bit_cnt4 = 0;
    1:  bit_cnt4 = 1;
    2:  bit_cnt4 = 1;
    3:  bit_cnt4 = 2;
    4:  bit_cnt4 = 1;
    5:  bit_cnt4 = 2;
    6:  bit_cnt4 = 2;
    7:  bit_cnt4 = 3;
    8:  bit_cnt4 = 1;
    9:  bit_cnt4 = 2;
    10: bit_cnt4 = 2;
    11: bit_cnt4 = 3;
    12: bit_cnt4 = 2;
    13: bit_cnt4 = 3;
    14: bit_cnt4 = 3;
    15: bit_cnt4 = 4;
    endcase
    end
endfunction
 
function [3:0] bit_cnt8;
input   [7:0]   bits;
    begin
    bit_cnt8 = bit_cnt4(bits[3:0]) + bit_cnt4(bits[7:4]);
    end
endfunction
 
always @(posedge clk_xgmii_rx or negedge reset_xgmii_rx_n) begin
 
    if (reset_xgmii_rx_n == 1'b0) begin
 
        xgmii_rxd_d1 <= 32'b0;
        xgmii_rxc_d1 <= 4'b0;
 
        xgxs_rxd_barrel <= 64'b0;
        xgxs_rxc_barrel <= 8'b0;
 
        xgxs_rxd_barrel_d1 <= 64'b0;
        xgxs_rxc_barrel_d1 <= 8'b0;
 
        barrel_shift <= 1'b0;
 
        local_fault_msg_det <= 2'b0;
        remote_fault_msg_det <= 2'b0;
 
        crc32_d64 <= 32'b0;
        crc32_d8 <= 32'b0;
        crc_bytes <= 4'b0;
 
        crc_shift_data <= 64'b0;
        crc_done <= 1'b0;
        crc_rx <= 32'b0;
 
        pause_frame_hold <= 1'b0;
 
        status_crc_error_tog <= 1'b0;
        status_fragment_error_tog <= 1'b0;
        status_lenght_error_tog <= 1'b0;
        status_rxdfifo_ovflow_tog <= 1'b0;
 
        status_pause_frame_rx_tog <= 1'b0;
 
        rxsfifo_wen <= 1'b0;
        rxsfifo_wdata <= 14'b0;
 
        datamask <= 8'b0;
 
        lenght_error <= 1'b0;
 
    end
    else begin
 
        rxsfifo_wen <= 1'b0;
        rxsfifo_wdata <= frame_lenght;
 
        lenght_error <= 1'b0;
 
        //---
        // Link status RC layer
        // Look for local/remote messages on lower 4 lanes and upper
        // 4 lanes. This is a 64-bit interface but look at each 32-bit
        // independantly.
 
        local_fault_msg_det[1] <= (xgmii_rxd[63:32] ==
                                   {`LOCAL_FAULT, 8'h0, 8'h0, `SEQUENCE} &&
                                   xgmii_rxc[7:4] == 4'b0001);
 
        local_fault_msg_det[0] <= (xgmii_rxd[31:0] ==
                                   {`LOCAL_FAULT, 8'h0, 8'h0, `SEQUENCE} &&
                                   xgmii_rxc[3:0] == 4'b0001);
 
        remote_fault_msg_det[1] <= (xgmii_rxd[63:32] ==
                                    {`REMOTE_FAULT, 8'h0, 8'h0, `SEQUENCE} &&
                                    xgmii_rxc[7:4] == 4'b0001);
 
        remote_fault_msg_det[0] <= (xgmii_rxd[31:0] ==
                                    {`REMOTE_FAULT, 8'h0, 8'h0, `SEQUENCE} &&
                                    xgmii_rxc[3:0] == 4'b0001);
 
 
        //---
        // Rotating barrel. This function allow us to always align the start of
        // a frame with LANE0. If frame starts in LANE4, it will be shifted 4 bytes
        // to LANE0, thus reducing the amount of logic needed at the next stage.
 
        xgmii_rxd_d1[63:32] <= xgmii_rxd[63:32];
        xgmii_rxc_d1[7:4] <= xgmii_rxc[7:4];
 
        if (xgmii_rxd[`LANE0] == `START && xgmii_rxc[0]) begin
 
            xgxs_rxd_barrel <= xgmii_rxd;
            xgxs_rxc_barrel <= xgmii_rxc;
 
            barrel_shift <= 1'b0;
 
        end
        else if (xgmii_rxd[`LANE4] == `START && xgmii_rxc[4]) begin
 
            xgxs_rxd_barrel[63:32] <= xgmii_rxd[31:0];
            xgxs_rxc_barrel[7:4] <= xgmii_rxc[3:0];
 
            if (barrel_shift) begin
                xgxs_rxd_barrel[31:0] <= xgmii_rxd_d1[63:32];
                xgxs_rxc_barrel[3:0] <= xgmii_rxc_d1[7:4];
            end
            else begin
                xgxs_rxd_barrel[31:0] <= 32'h07070707;
                xgxs_rxc_barrel[3:0] <= 4'hf;
            end
 
            barrel_shift <= 1'b1;
 
        end
        else if (barrel_shift) begin
 
            xgxs_rxd_barrel <= {xgmii_rxd[31:0], xgmii_rxd_d1[63:32]};
            xgxs_rxc_barrel <= {xgmii_rxc[3:0], xgmii_rxc_d1[7:4]};
 
        end
        else begin
 
            xgxs_rxd_barrel <= xgmii_rxd;
            xgxs_rxc_barrel <= xgmii_rxc;
 
        end
 
        xgxs_rxd_barrel_d1 <= xgxs_rxd_barrel;
        xgxs_rxc_barrel_d1 <= xgxs_rxc_barrel;
 
        //---
        // Mask for end-of-frame
 
        datamask[0] <= addmask[0];
        datamask[1] <= &addmask[1:0];
        datamask[2] <= &addmask[2:0];
        datamask[3] <= &addmask[3:0];
        datamask[4] <= &addmask[4:0];
        datamask[5] <= &addmask[5:0];
        datamask[6] <= &addmask[6:0];
        datamask[7] <= &addmask[7:0];
 
        //---
        // When final CRC calculation begins we capture info relevant to
        // current frame CRC claculation continues while next frame is
        // being received.
 
        if (crc_start_8b) begin
 
            pause_frame_hold <= pause_frame;
 
        end
 
        //---
        // CRC Checking
 
        crc_rx <= next_crc_rx;
 
        if (crc_clear) begin
 
            // CRC is cleared at the beginning of the frame, calculate
            // 64-bit at a time otherwise
 
            crc32_d64 <= 32'hffffffff;
 
        end
        else begin
 
            crc32_d64 <= nextCRC32_D64(reverse_64b(xgxs_rxd_barrel_d1), crc32_d64);
 
        end
 
        if (crc_bytes != 4'b0) begin
 
            // When reaching the end of the frame we switch from 64-bit mode
            // to 8-bit mode to accomodate odd number of bytes in the frame.
            // crc_bytes indicated the number of remaining payload byte to
            // compute CRC on. Calculate and decrement until it reaches 0.
 
            if (crc_bytes == 4'b1) begin
                crc_done <= 1'b1;
            end
 
            crc32_d8 <= nextCRC32_D8(reverse_8b(crc_shift_data[7:0]), crc32_d8);
            crc_shift_data <= {8'h00, crc_shift_data[63:8]};
            crc_bytes <= crc_bytes - 4'b1;
 
        end
        else if (crc_bytes == 4'b0) begin
 
            // Per Clause 46. Control code during data must be reported
            // as a CRC error. Indicated here by coding_error. Corrupt CRC
            // if coding error is detected.
 
            if (coding_error || next_coding_error) begin
                crc32_d8 <= ~crc32_d64;
            end
            else begin
                crc32_d8 <= crc32_d64;
            end
 
            crc_done <= 1'b0;
 
            crc_shift_data <= xgxs_rxd_barrel_d1;
            crc_bytes <= next_crc_bytes;
 
        end
 
        //---
        // Error detection
 
        if (crc_done && !crc_good) begin
            status_crc_error_tog <= ~status_crc_error_tog;
        end
 
        if (fragment_error) begin
            status_fragment_error_tog <= ~status_fragment_error_tog;
        end
 
        if (rxd_ovflow_error) begin
            status_rxdfifo_ovflow_tog <= ~status_rxdfifo_ovflow_tog;
        end
 
        //---
        // Frame receive indication
 
        if (good_pause_frame) begin
            status_pause_frame_rx_tog <= ~status_pause_frame_rx_tog;
        end
 
        if (frame_end_flag) begin
            rxsfifo_wen <= 1'b1;
        end
 
        //---
        // Check frame lenght
 
        if (frame_end_flag && frame_lenght > `MAX_FRAME_SIZE) begin
            lenght_error <= 1'b1;
            status_lenght_error_tog <= ~status_lenght_error_tog;
        end
 
    end
 
end
 
 
always @(/*AS*/crc32_d8 or crc_done or crc_rx or pause_frame_hold) begin
 
 
    crc_good = 1'b0;
    good_pause_frame = 1'b0;
 
    if (crc_done) begin
 
        // Check CRC. If this is a pause frame, report it to cpu.
 
        if (crc_rx == ~reverse_32b(crc32_d8)) begin
            crc_good = 1'b1;
            good_pause_frame = pause_frame_hold;
        end
 
    end
 
end
 
always @(posedge clk_xgmii_rx or negedge reset_xgmii_rx_n) begin
 
    if (reset_xgmii_rx_n == 1'b0) begin
 
        curr_state <= SM_IDLE;
        curr_byte_cnt <= 14'b0;
        frame_end_flag <= 1'b0;
        frame_end_bytes <= 3'b0;
        coding_error <= 1'b0;
        pause_frame <= 1'b0;
 
    end
    else begin
 
        curr_state <= next_state;
        curr_byte_cnt <= next_byte_cnt;
        frame_end_flag <= next_frame_end_flag;
        frame_end_bytes <= next_frame_end_bytes;
        coding_error <= next_coding_error;
        pause_frame <= next_pause_frame;
 
    end
 
end
 
 
always @(/*AS*/coding_error or crc_rx or curr_byte_cnt or curr_state
         or datamask or frame_end_bytes or pause_frame
         or xgxs_rxc_barrel or xgxs_rxc_barrel_d1 or xgxs_rxd_barrel
         or xgxs_rxd_barrel_d1) begin
 
    next_state = curr_state;
 
    rxhfifo_wdata = xgxs_rxd_barrel_d1;
    rxhfifo_wstatus = `RXSTATUS_NONE;
    rxhfifo_wen = 1'b0;
 
    next_crc_bytes = 4'b0;
    next_crc_rx = crc_rx;
    crc_start_8b = 1'b0;
    crc_clear = 1'b0;
 
    next_byte_cnt = curr_byte_cnt;
    next_frame_end_flag = 1'b0;
    next_frame_end_bytes = 3'b0;
 
    fragment_error = 1'b0;
 
    frame_lenght = curr_byte_cnt + {11'b0, frame_end_bytes};
 
    next_coding_error = coding_error;
    next_pause_frame = pause_frame;
 
    addmask[0] = !(xgxs_rxd_barrel[`LANE0] == `TERMINATE && xgxs_rxc_barrel[0]);
    addmask[1] = !(xgxs_rxd_barrel[`LANE1] == `TERMINATE && xgxs_rxc_barrel[1]);
    addmask[2] = !(xgxs_rxd_barrel[`LANE2] == `TERMINATE && xgxs_rxc_barrel[2]);
    addmask[3] = !(xgxs_rxd_barrel[`LANE3] == `TERMINATE && xgxs_rxc_barrel[3]);
    addmask[4] = !(xgxs_rxd_barrel[`LANE4] == `TERMINATE && xgxs_rxc_barrel[4]);
    addmask[5] = !(xgxs_rxd_barrel[`LANE5] == `TERMINATE && xgxs_rxc_barrel[5]);
    addmask[6] = !(xgxs_rxd_barrel[`LANE6] == `TERMINATE && xgxs_rxc_barrel[6]);
    addmask[7] = !(xgxs_rxd_barrel[`LANE7] == `TERMINATE && xgxs_rxc_barrel[7]);
 
    case (curr_state)
 
        SM_IDLE:
          begin
 
              next_byte_cnt = 14'b0;
              crc_clear = 1'b1;
              next_coding_error = 1'b0;
              next_pause_frame = 1'b0;
 
 
              // Detect the start of a frame
 
              if (xgxs_rxd_barrel_d1[`LANE0] == `START && xgxs_rxc_barrel_d1[0] &&
                  xgxs_rxd_barrel_d1[`LANE1] == `PREAMBLE && !xgxs_rxc_barrel_d1[1] &&
                  xgxs_rxd_barrel_d1[`LANE2] == `PREAMBLE && !xgxs_rxc_barrel_d1[2] &&
                  xgxs_rxd_barrel_d1[`LANE3] == `PREAMBLE && !xgxs_rxc_barrel_d1[3] &&
                  xgxs_rxd_barrel_d1[`LANE4] == `PREAMBLE && !xgxs_rxc_barrel_d1[4] &&
                  xgxs_rxd_barrel_d1[`LANE5] == `PREAMBLE && !xgxs_rxc_barrel_d1[5] &&
                  xgxs_rxd_barrel_d1[`LANE6] == `PREAMBLE && !xgxs_rxc_barrel_d1[6] &&
                  xgxs_rxd_barrel_d1[`LANE7] == `SFD && !xgxs_rxc_barrel_d1[7]) begin
 
                  next_state = SM_RX;
              end
 
          end
 
        SM_RX:
          begin
 
              // Pause frames are filtered
 
              rxhfifo_wen = !pause_frame;
 
 
              if (xgxs_rxd_barrel_d1[`LANE0] == `START && xgxs_rxc_barrel_d1[0] &&
                  xgxs_rxd_barrel_d1[`LANE7] == `SFD && !xgxs_rxc_barrel_d1[7]) begin
 
                  // Fragment received, if we are still at SOP stage don't store
                  // the frame. If not, write a fake EOP and flag frame as bad.
 
                  next_byte_cnt = 14'b0;
                  crc_clear = 1'b1;
                  next_coding_error = 1'b0;
 
                  fragment_error = 1'b1;
                  rxhfifo_wstatus[`RXSTATUS_ERR] = 1'b1;
 
                  if (curr_byte_cnt == 14'b0) begin
                      rxhfifo_wen = 1'b0;
                  end
                  else begin
                      rxhfifo_wstatus[`RXSTATUS_EOP] = 1'b1;
                  end
 
              end
              else if (curr_byte_cnt > 14'd16100) begin
 
                  // Frame too long, TERMMINATE must have been corrupted.
                  // Abort transfer, write a fake EOP, report as fragment.
 
                  fragment_error = 1'b1;
                  rxhfifo_wstatus[`RXSTATUS_ERR] = 1'b1;
 
                  rxhfifo_wstatus[`RXSTATUS_EOP] = 1'b1;
                  next_state = SM_IDLE;
 
              end
              else begin
 
                  // Pause frame receive, these frame will be filtered
 
                  if (curr_byte_cnt == 14'd0 &&
                      xgxs_rxd_barrel_d1[47:0] == `PAUSE_FRAME) begin
 
                      rxhfifo_wen = 1'b0;
                      next_pause_frame = 1'b1;
                  end
 
 
                  // Control character during data phase, force CRC error
 
                  if (|(xgxs_rxc_barrel_d1 & datamask)) begin
 
                      next_coding_error = 1'b1;
                  end
 
 
                  // Write SOP to status bits during first byte
 
                  if (curr_byte_cnt == 14'b0) begin
                      rxhfifo_wstatus[`RXSTATUS_SOP] = 1'b1;
                  end
 
                  /* verilator lint_off WIDTH */
                  //next_byte_cnt = curr_byte_cnt +
                  //                addmask[0] + addmask[1] + addmask[2] + addmask[3] +
                  //                addmask[4] + addmask[5] + addmask[6] + addmask[7];
                  /* verilator lint_on WIDTH */
                  // don't infer a chain of adders
                  next_byte_cnt = curr_byte_cnt + {10'b0, bit_cnt8(datamask[7:0])};
 
 
                  // We will not write to the fifo if all is left
                  // are four or less bytes of crc. We also strip off the
                  // crc, which requires looking one cycle ahead
                  // wstatus:
                  //   [2:0] modulus of packet length
 
                  // Look one cycle ahead for TERMINATE in lanes 0 to 4
 
                  if (xgxs_rxd_barrel[`LANE4] == `TERMINATE && xgxs_rxc_barrel[4]) begin
 
                      rxhfifo_wstatus[`RXSTATUS_EOP] = 1'b1;
                      rxhfifo_wstatus[2:0] = 3'd0;
 
                      crc_start_8b = 1'b1;
                      next_crc_bytes = 4'd8;
                      next_crc_rx = xgxs_rxd_barrel[31:0];
 
                      next_frame_end_flag = 1'b1;
                      next_frame_end_bytes = 3'd4;
 
                      next_state = SM_IDLE;
 
                  end
 
                  if (xgxs_rxd_barrel[`LANE3] == `TERMINATE && xgxs_rxc_barrel[3]) begin
 
                      rxhfifo_wstatus[`RXSTATUS_EOP] = 1'b1;
                      rxhfifo_wstatus[2:0] = 3'd7;
 
                      crc_start_8b = 1'b1;
                      next_crc_bytes = 4'd7;
                      next_crc_rx = {xgxs_rxd_barrel[23:0], xgxs_rxd_barrel_d1[63:56]};
 
                      next_frame_end_flag = 1'b1;
                      next_frame_end_bytes = 3'd3;
 
                      next_state = SM_IDLE;
 
                  end
 
                  if (xgxs_rxd_barrel[`LANE2] == `TERMINATE && xgxs_rxc_barrel[2]) begin
 
                      rxhfifo_wstatus[`RXSTATUS_EOP] = 1'b1;
                      rxhfifo_wstatus[2:0] = 3'd6;
 
                      crc_start_8b = 1'b1;
                      next_crc_bytes = 4'd6;
                      next_crc_rx = {xgxs_rxd_barrel[15:0], xgxs_rxd_barrel_d1[63:48]};
 
                      next_frame_end_flag = 1'b1;
                      next_frame_end_bytes = 3'd2;
 
                      next_state = SM_IDLE;
 
                  end
 
                  if (xgxs_rxd_barrel[`LANE1] == `TERMINATE && xgxs_rxc_barrel[1]) begin
 
                      rxhfifo_wstatus[`RXSTATUS_EOP] = 1'b1;
                      rxhfifo_wstatus[2:0] = 3'd5;
 
                      crc_start_8b = 1'b1;
                      next_crc_bytes = 4'd5;
                      next_crc_rx = {xgxs_rxd_barrel[7:0], xgxs_rxd_barrel_d1[63:40]};
 
                      next_frame_end_flag = 1'b1;
                      next_frame_end_bytes = 3'd1;
 
                      next_state = SM_IDLE;
 
                  end
 
                  if (xgxs_rxd_barrel[`LANE0] == `TERMINATE && xgxs_rxc_barrel[0]) begin
 
                      rxhfifo_wstatus[`RXSTATUS_EOP] = 1'b1;
                      rxhfifo_wstatus[2:0] = 3'd4;
 
                      crc_start_8b = 1'b1;
                      next_crc_bytes = 4'd4;
                      next_crc_rx = xgxs_rxd_barrel_d1[63:32];
 
                      next_frame_end_flag = 1'b1;
 
                      next_state = SM_IDLE;
 
                  end
 
                  // Look at current cycle for TERMINATE in lanes 5 to 7
 
                  if (xgxs_rxd_barrel_d1[`LANE7] == `TERMINATE &&
                      xgxs_rxc_barrel_d1[7]) begin
 
                      rxhfifo_wstatus[`RXSTATUS_EOP] = 1'b1;
                      rxhfifo_wstatus[2:0] = 3'd3;
 
                      crc_start_8b = 1'b1;
                      next_crc_bytes = 4'd3;
                      next_crc_rx = xgxs_rxd_barrel_d1[55:24];
 
                      next_frame_end_flag = 1'b1;
 
                      next_state = SM_IDLE;
 
                  end
 
                  if (xgxs_rxd_barrel_d1[`LANE6] == `TERMINATE &&
                      xgxs_rxc_barrel_d1[6]) begin
 
                      rxhfifo_wstatus[`RXSTATUS_EOP] = 1'b1;
                      rxhfifo_wstatus[2:0] = 3'd2;
 
                      crc_start_8b = 1'b1;
                      next_crc_bytes = 4'd2;
                      next_crc_rx = xgxs_rxd_barrel_d1[47:16];
 
                      next_frame_end_flag = 1'b1;
 
                      next_state = SM_IDLE;
 
                  end
 
                  if (xgxs_rxd_barrel_d1[`LANE5] == `TERMINATE &&
                      xgxs_rxc_barrel_d1[5]) begin
 
                      rxhfifo_wstatus[`RXSTATUS_EOP] = 1'b1;
                      rxhfifo_wstatus[2:0] = 3'd1;
 
                      crc_start_8b = 1'b1;
                      next_crc_bytes = 4'd1;
                      next_crc_rx = xgxs_rxd_barrel_d1[39:8];
 
                      next_frame_end_flag = 1'b1;
 
                      next_state = SM_IDLE;
 
                  end
              end
          end
 
        default:
          begin
              next_state = SM_IDLE;
          end
 
    endcase
 
end
 
 
always @(posedge clk_xgmii_rx or negedge reset_xgmii_rx_n) begin
 
    if (reset_xgmii_rx_n == 1'b0) begin
 
        rxhfifo_ralmost_empty_d1 <= 1'b1;
 
        drop_data <= 1'b0;
 
        pkt_pending <= 1'b0;
 
        rxhfifo_ren_d1 <= 1'b0;
 
    end
    else begin
 
        rxhfifo_ralmost_empty_d1 <= rxhfifo_ralmost_empty;
 
        drop_data <= next_drop_data;
 
        pkt_pending <= rxhfifo_ren;
 
        rxhfifo_ren_d1 <= rxhfifo_ren;
 
    end
 
end
 
always @(/*AS*/crc_done or crc_good or drop_data or lenght_error
         or pkt_pending or rxdfifo_wfull or rxhfifo_ralmost_empty_d1
         or rxhfifo_rdata or rxhfifo_ren_d1 or rxhfifo_rstatus) begin
 
    rxd_ovflow_error = 1'b0;
 
    rxdfifo_wdata = rxhfifo_rdata;
    rxdfifo_wstatus = rxhfifo_rstatus;
 
    next_drop_data = drop_data;
 
 
    // There must be at least 8 words in holding FIFO before we start reading.
    // This provides enough time for CRC calculation.
 
    rxhfifo_ren = !rxhfifo_ralmost_empty_d1 ||
                  (pkt_pending && !rxhfifo_rstatus[`RXSTATUS_EOP]);
 
 
    if (rxhfifo_ren_d1 && rxhfifo_rstatus[`RXSTATUS_SOP]) begin
 
        // Reset drop flag on SOP
 
        next_drop_data = 1'b0;
 
    end
 
    if (rxhfifo_ren_d1 && rxdfifo_wfull && !next_drop_data) begin
 
        // FIFO overflow, abort transfer. The rest of the frame
        // will be dropped. Since we can't put an EOP indication
        // in a fifo already full, there will be no EOP and receive
        // side will need to sync on next SOP.
 
        rxd_ovflow_error = 1'b1;
        next_drop_data = 1'b1;
 
    end
 
 
    rxdfifo_wen = rxhfifo_ren_d1 && !next_drop_data;
 
 
 
    if ((crc_done && !crc_good) || lenght_error) begin
 
        // Flag packet with error when CRC error is detected
 
        rxdfifo_wstatus[`RXSTATUS_ERR] = 1'b1;
 
    end
 
end
 
endmodule
