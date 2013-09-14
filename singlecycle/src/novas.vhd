package pkg is
   attribute foreign : string;
 
   procedure fsdbDumpfile (file_name : in string);
   attribute foreign of fsdbDumpfile : procedure is "fliparseTraceInit ./novas_fli.so";
--linux: current path is the modelsim work path , i.e. /prune/running/runsim_rtl
--windows: current path is the modedsim environment path, i.e. \win32\
   procedure fsdbDumpvars (depth : in integer;
                           region_name : in string);
   attribute foreign of fsdbDumpvars : procedure is "fliparsePartial ./novas_fli.so";
 end;
 --novas
 package body pkg is 
     procedure fsdbDumpfile(file_name : in string) is
     begin
         assert false report "ERROR : foreign subprogram not called" severity note;
     end;
     
     procedure fsdbDumpvars(depth : in integer;
                            region_name : in string) is
     begin
         assert false report "ERROR : foreign subprogram not called" severity note;
     end;
 end; 
 
 entity novas is end; 
 
 architecture novas_arch of novas is
   attribute foreign : string;
   attribute foreign of novas_arch : architecture is "fliparseCommand novas_fli.dll";
 begin
 end;
