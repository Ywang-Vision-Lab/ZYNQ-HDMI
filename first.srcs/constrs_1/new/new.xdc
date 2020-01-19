set_property -dict {PACKAGE_PIN L16  IOSTANDARD TMDS_33 } [get_ports {tmds_data_p[2]}]
set_property -dict {PACKAGE_PIN M17  IOSTANDARD TMDS_33 } [get_ports {tmds_data_p[1]}]
set_property -dict {PACKAGE_PIN L19  IOSTANDARD TMDS_33 } [get_ports {tmds_data_p[0]}]
set_property -dict {PACKAGE_PIN K17  IOSTANDARD TMDS_33 } [get_ports tmds_clk_p]

set_property -dict {PACKAGE_PIN D18  IOSTANDARD LVCMOS33} [get_ports tmds_oen]
set_property -dict {PACKAGE_PIN H16  IOSTANDARD LVCMOS33} [get_ports sys_clk]
set_property -dict {PACKAGE_PIN M14  IOSTANDARD LVCMOS33} [get_ports sys_rst_n]