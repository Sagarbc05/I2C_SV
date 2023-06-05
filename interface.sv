//------------------------------------------------------------------------------
// I2C protocol systemverilog verification environment
// Component name : Interface
//------------------------------------------------------------------------------

interface i2c_if(input bit clk);

  logic rst;
  logic [6:0] addr;
  logic [7:0] data_in;
  logic enable;
  logic rw;
  logic [7:0] data_out;
  logic ready;
  wire i2c_sda;  // As logic cannotbe connected to inout type variable
  wire i2c_scl;

  // Clocking block (find a way)
endinterface : i2c_if