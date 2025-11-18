`ifndef GPIO_UVC_DRIVER_SV
`define GPIO_UVC_DRIVER_SV

class gpio_uvc_driver extends uvm_driver #(gpio_uvc_sequence_item);

  `uvm_component_utils(gpio_uvc_driver)

  virtual gpio_uvc_if vif;
  gpio_uvc_config     m_config;

  extern function new(string name, uvm_component parent);

  extern task run_phase(uvm_phase phase);
  extern task do_drive();
  extern task drive_sync();
  extern task drive_async();

endclass : gpio_uvc_driver


function gpio_uvc_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


task gpio_uvc_driver::run_phase(uvm_phase phase);
  vif.gpio_pin = m_config.start_value;
  `uvm_info(get_type_name(), {"\n------ DRIVER (GPIO_UVC) INITIAL VALUE -----\n", $sformatf("gpio_pin = 'h%4h", m_config.start_value)}, UVM_DEBUG)

  forever begin
    seq_item_port.get_next_item(req);
    do_drive();
    seq_item_port.item_done();
  end
endtask : run_phase


task gpio_uvc_driver::drive_sync();
//  `uvm_info(get_type_name(), $sformatf("ALIGN TYPE = %0d", req.m_align_type), UVM_LOW)
  if (req.m_align_type == GPIO_UVC_ITEM_ALIGN_TYPE_RISING) begin
    @(vif.cb_drv);
    `uvm_info(get_type_name(), {"\n--- DRIVER SINCRONO RISING (GPIO_UVC) ---", req.convert2string()
              }, UVM_DEBUG)
    vif.cb_drv.gpio_pin <= req.m_gpio_pin;
    @(vif.cb_drv_neg);
    if (req.m_delay_enable == GPIO_UVC_ITEM_DELAY_ON) begin
      repeat (req.m_delay_cycles) begin
        @(vif.cb_drv_neg);
      end
    end

  end else begin

    @(vif.cb_drv_neg);
    `uvm_info(get_type_name(), {"\n--- DRIVER SINCRONO FALLING(GPIO_UVC) ---", req.convert2string()
              }, UVM_DEBUG)
    vif.cb_drv_neg.gpio_pin <= req.m_gpio_pin;
    @(vif.cb_drv);
    if (req.m_delay_enable == GPIO_UVC_ITEM_DELAY_ON) begin
      repeat (req.m_delay_cycles) begin
        @(vif.cb_drv);
      end
    end
  end

endtask : drive_sync


task gpio_uvc_driver::drive_async();
  vif.gpio_pin = req.m_gpio_pin;
  `uvm_info(get_type_name(), {"\n--- DRIVER ASINCRONO(GPIO_UVC) ---", req.convert2string()},
            UVM_DEBUG)

  if (req.m_delay_enable == GPIO_UVC_ITEM_DELAY_ON) begin
    #(req.m_delay_duration_ps * 1ps);
  end else begin
    @(vif.cb_drv);
  end
endtask : drive_async


task gpio_uvc_driver::do_drive();

  if (req.m_trans_type == GPIO_UVC_ITEM_ASYNC) begin
    drive_async();
  end else begin
    drive_sync();
  end

endtask : do_drive

`endif  // GPIO_UVC_DRIVER_SV
