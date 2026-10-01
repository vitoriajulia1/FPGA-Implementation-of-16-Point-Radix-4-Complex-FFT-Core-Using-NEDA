architecture a3 of radix2 is 
    signal som, dif : sfixed(vecteurin'left+1 downto vecteurin'right); 
begin  
    som <= x0+x1;
    dif <= x0-x1;

    process (d2, som, dif)
    begin
        if (d2 = '0') then
            yp <= resize(som, yp'left,yp'right,fixed_wrap,fixed_truncate);
            ym <= resize(dif, ym'left,ym'right,fixed_wrap,fixed_truncate);
	    --yp <= som(vecteurin'left downto vecteurin'right);
            --ym <= dif(vecteurin'left downto vecteurin'right);
        else
            yp <= resize(som/to_sfixed(2,2,0), yp'left,yp'right,fixed_wrap,fixed_truncate);
            ym <= resize(dif/to_sfixed(2,2,0), ym'left,ym'right,fixed_wrap,fixed_truncate);
            
	    --yp <= som(vecteurin'left downto vecteurin'right-1);
            --ym <= dif(vecteurin'left downto vecteurin'right-1);
        end if;
    end process;
end architecture a3;
