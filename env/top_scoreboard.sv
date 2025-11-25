`ifndef TOP_SCOREBOARD_SV
`define TOP_SCOREBOARD_SV

class top_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(top_scoreboard)

  `uvm_analysis_imp_decl(_port_a)
  uvm_analysis_imp_port_a #(gpio_uvc_sequence_item, top_scoreboard) port_a_imp_export;

  `uvm_analysis_imp_decl(_port_b)
  uvm_analysis_imp_port_b #(gpio_uvc_sequence_item, top_scoreboard) port_b_imp_export;

  `uvm_analysis_imp_decl(_port_c)
  uvm_analysis_imp_port_c #(gpio_uvc_sequence_item, top_scoreboard) port_c_imp_export;

  // Statistics
  int unsigned m_num_passed = 0;
  int unsigned m_num_failed = 0;

  // Queue to store data
  gpio_uvc_sequence_item m_a_queue[$];
  gpio_uvc_sequence_item m_b_queue[$];
  gpio_uvc_sequence_item m_c_queue[$];

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
  extern function int ref_model(input gpio_uvc_sequence_item trans_A,
                                gpio_uvc_sequence_item trans_B);

  extern function void write_port_a(input gpio_uvc_sequence_item t);
  extern function void write_port_b(input gpio_uvc_sequence_item t);
  extern function void write_port_c(input gpio_uvc_sequence_item t);


endclass : top_scoreboard


function top_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void top_scoreboard::build_phase(uvm_phase phase);
  // Implementation Export
  port_a_imp_export = new("port_a_imp_export", this);
  port_b_imp_export = new("port_b_imp_export", this);
  port_c_imp_export = new("port_c_imp_export", this);

endfunction : build_phase

function void top_scoreboard::write_port_a(input gpio_uvc_sequence_item t);
  gpio_uvc_sequence_item received_trans;
  received_trans = gpio_uvc_sequence_item::type_id::create("received_trans");
  received_trans.copy(t);
  m_a_queue.push_back(received_trans);
endfunction : write_port_a

function void top_scoreboard::write_port_b(input gpio_uvc_sequence_item t);
  gpio_uvc_sequence_item received_trans;
  received_trans = gpio_uvc_sequence_item::type_id::create("received_trans");
  received_trans.copy(t);
  m_a_queue.push_back(received_trans);
endfunction : write_port_b

function void top_scoreboard::write_port_c(input gpio_uvc_sequence_item t);
  gpio_uvc_sequence_item received_trans;
  received_trans = gpio_uvc_sequence_item::type_id::create("received_trans");
  received_trans.copy(t);
  m_a_queue.push_back(received_trans);
endfunction : write_port_c



task top_scoreboard::run_phase(uvm_phase phase);
  // Variables
  string s;


endtask : run_phase

function int top_scoreboard::ref_model(input gpio_uvc_sequence_item trans_A,
                                       gpio_uvc_sequence_item trans_B);
  return (trans_A.m_gpio_pin[7:0] + trans_B.m_gpio_pin[7:0]);
endfunction : ref_model


function void top_scoreboard::report_phase(uvm_phase phase);
  // imprimimos las queue
  // string s;
  // foreach (m_a_queue[i]) begin
  //   s = {s, $sformatf("\nTRANS[%3d]: \n ------ SCOREBOARD (ADDER UVC) ------  ", i), m_a_queue[i].convert2string(), "\n"};
  // end
  //       `uvm_info(get_type_name(), s, UVM_DEBUG)
  //        s="";
  `uvm_info(get_type_name(), $sformatf("PASSED = %3d, FAILED = %3d", m_num_passed, m_num_failed),
            UVM_MEDIUM)

endfunction : report_phase


`endif  // TOP_SCOREBOARD_SV
