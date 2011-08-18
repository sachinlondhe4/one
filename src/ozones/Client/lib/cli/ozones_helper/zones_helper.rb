require 'cli/ozones_helper'
require 'cli/one_helper/onehost_helper'
require 'cli/one_helper/onevm_helper'
require 'cli/one_helper/oneimage_helper'
require 'cli/one_helper/onevnet_helper'
require 'cli/one_helper/onetemplate_helper'
require 'cli/one_helper/oneuser_helper'


class ZonesHelper < OZonesHelper::OZHelper
    def initialize(kind, user=nil, pass=nil, endpoint_str=nil,
                       timeout=nil, debug_flag=true)
        @zone_str = kind
        super(user, pass, endpoint_str, timeout, debug_flag)
    end

    def create_resource(template)
      super(@zone_str,template)
    end

    def list_pool(options)
        super(@zone_str,options)
    end

    def show_resource(id, options)
        super(@zone_str,id, options)
    end
    
    def delete_resource(id, options)
        super(@zone_str,id, options)
    end
    
    private

    def format_resource(zone, options)
        str_h1="%-61s"
        str="%-15s: %-20s"
        
        CLIHelper.print_header(str_h1 % ["ZONE #{zone['name']} INFORMATION"])
    
        puts str % ["ID ",        zone['id'].to_s]
        puts str % ["NAME ",      zone['name'].to_s]
        puts str % ["ZONE ADMIN ",zone['onename'].to_s]
        puts str % ["ZONE PASS ", zone['onepass'].to_s]        
        puts str % ["ENDPOINT ",  zone['endpoint'].to_s]
        puts str % ["# VDCS ",    zone['vdcs'].size.to_s]
        puts
        
        if zone['vdcs'].size == 0
            return [0, zone]
        end
    
        CLIHelper.print_header(str_h1 % ["VDCS INFORMATION"])
     
         st=CLIHelper::ShowTable.new(nil) do
            column :ID, "Identifier for VDC", :size=>4 do |d,e|
                d["id"]
            end

            column :NAME, "Name of the VDC", :right, :size=>15 do |d,e|
                d["name"]
            end
        
            default :ID, :NAME
        end

        st.show(zone["vdcs"], options)
        
        return [0, zone]
    end

    def format_pool(pool, options)   
        st=CLIHelper::ShowTable.new(nil) do
            column :ID, "Identifier for Zone", :size=>4 do |d,e|
                d["id"]
            end

            column :NAME, "Name of the Zone", :right, :size=>15 do |d,e|
                d["name"]
            end

            column :ENDPOINT, "Endpoint of the Zone", :right, :size=>40 do |d,e|
                d["endpoint"]
            end
        
            default :ID, :NAME, :ENDPOINT
        end
        st.show(pool[@zone_str.upcase], options)
        
        return 0
    end
end