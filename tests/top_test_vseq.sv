`ifndef TOP_TEST_VSEQ_SV
`define TOP_TEST_VSEQ_SV

class top_test_vseq extends uvm_sequence;

  `uvm_object_utils(top_test_vseq)
  `uvm_declare_p_sequencer(top_vsqr)

  rand int unsigned iter;

  extern function new(string name = "");

  extern task port_rst_seq();
  extern task port_a_seq(string filename);
  extern task port_b_seq(string filename);
  extern task body();

  constraint c_iter {iter inside {[1 : 2]};}

endclass : top_test_vseq


function top_test_vseq::new(string name = "");
  super.new(name);
endfunction : new


task top_test_vseq::port_rst_seq();
  gpio_uvc_sequence_pulse seq;
  seq = gpio_uvc_sequence_pulse::type_id::create("seq");

  if (!seq.randomize() with {
    m_pin_assert.m_gpio_pin == 1'b1;
    m_pin_assert.m_trans_type == GPIO_UVC_ITEM_SYNC;
    m_pin_assert.m_delay_enable == GPIO_UVC_ITEM_DELAY_OFF;
    m_pin_assert.m_align_type == GPIO_UVC_ITEM_ALIGN_TYPE_RISING;
    m_pin_deassert.m_gpio_pin == 1'b0;
    m_pin_deassert.m_trans_type == GPIO_UVC_ITEM_SYNC;
    m_pin_deassert.m_delay_enable == GPIO_UVC_ITEM_DELAY_OFF;
    m_pin_deassert.m_align_type == GPIO_UVC_ITEM_ALIGN_TYPE_RISING;
  }) begin
    `uvm_fatal(get_name(), "Failed to randomize sequence")
  end
  seq.start(p_sequencer.m_port_rst_sequencer);
endtask : port_rst_seq

task top_test_vseq::port_a_seq(string filename);
  gpio_uvc_sequence_from_file seq;
  seq = gpio_uvc_sequence_from_file::type_id::create("seq");
  seq.m_file_name = {`GIT_DIR, filename};
  seq.start(p_sequencer.m_port_a_sequencer);
endtask : port_a_seq


task top_test_vseq::port_b_seq(string filename);
  gpio_uvc_sequence_from_file seq;
  seq = gpio_uvc_sequence_from_file::type_id::create("seq");
  seq.m_file_name = {`GIT_DIR, filename};
  seq.start(p_sequencer.m_port_b_sequencer);
endtask : port_b_seq


task top_test_vseq::body();
  // Teset reset sequence
  port_rst_seq();

  // Test read from file sequence
  #(200ns);
  fork
    port_a_seq("/sv/seqlib/sample.seq");
    port_b_seq("/sv/seqlib/sample.seq");
  join

  // Drain time 
  #(1000ns);
endtask : body

`endif  // TOP_TEST_VSEQ_SV
