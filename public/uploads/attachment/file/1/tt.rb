require 'net/http'
require 'uri'
require 'mysql'

def getstr(n)
	if n.to_i <= 9 
  		s = '0' + n.to_s
  else
		s = n.to_s
  end
end

def writeToMYSQL(s, id1)
	begin
		n = 0;
    sqlstr = ''
		con = Mysql.new 'localhost', 'nazip', 'qaz'
		s.each_line do |line|
      if n != 0
				subs=line.split(',')
        if n < 1000 
					sqlstr = "replace into share.sales(per,dt,tm,open_s,hight_s,low_s,close_s,vol_s, idticker ) values " if n == 1 
					sqlstr = sqlstr + ',' if n != 1
					sqlstr = sqlstr + 
                   "(#{subs[1]}, " +
                         "'" + subs[2] + "', " +
                         "'" + subs[3] + "', " +
                         "#{subs[4]}, #{subs[5]}, #{subs[6]}, #{subs[7]}, #{subs[8]}, #{id1} )"
					n = n+1
        else
					con.query sqlstr
					sqlstr = ''
					n = 1;
				end
			else
				n = 1
			end
		end
 		con.query sqlstr if sqlstr != ''
	rescue Mysql::Error => e
		puts e.errno
		puts e.error
	ensure
		con.close if con
	end
end


def loadOneTool(id1, em1, market1, code1, fname1, dayfrom1, monthfrom1, yearfrom1, dayto1, monthto1, yearto1)

	fromdt = getstr(dayfrom1) + '.' + getstr(monthfrom1.to_i+1) + '.' + yearfrom1 
	to_dt  = getstr(dayto1) + '.' + getstr(monthto1.to_i+1) + '.' + yearto1  

	queryStr = 'http://195.128.78.52/' + fname1 + '.txt?market=' + market1 +'&em='+ em1 + '&code=' + code1 +'&df=' + dayfrom1.to_s + '&mf='+ monthfrom1.to_s + 
             '&yf='+ yearfrom1+'&from='+fromdt+'&dt='+dayto1.to_s+'&mt='+monthto1.to_s+'&yt='+yearto1+'&to='+to_dt+'&p=2&f='+fname1+
             '&e=.txt&cn='+code1+'&dtf=1&tmf=1&MSOR=1&mstime=on&mstimever=1&sep=1&sep2=1&datf=1&at=1'

  rez = Net::HTTP.get(URI.parse(queryStr))
  writeToMYSQL(rez, id1)
end

# ruby t.rb GAZP abc 23 1 2015 24 1 2015


code  = ARGV[0].to_s
fname = 'abc'

dd = `date +%d` 
mf = `date +%m`
yf = `date +%Y`
mf1 = mf.to_i - 1

if dd.to_i == 1
	dayfrom = (`date +%d -d -1day`).chop
	monthfrom =  mf.to_i - 2
  if mf.to_i == 1 
    yearfrom = (yf.to_i-1).to_s.chop  
  else
    yearfrom = yf.chop  
  end
else
	dayfrom = dd.to_i-1  
	monthfrom =  mf.to_i - 1 
  yearfrom = yf.chop  
end

dayto = dd.to_i 
monthto = mf.to_i-1
yearto = yf.chop  

if code == 'all' 
		con = Mysql.new 'localhost', 'nazip', 'qaz'    
    rs = con.query "SELECT id, code, em, market FROM share.tools"
    rs.each_hash do |row|
      code1 = row['code']
      em1 = row['em']
      id1 = row['id']
      market1 = row['market']	
		loadOneTool(id1, em1, market1, code1, code1, dayfrom, monthfrom, yearfrom,dayto,monthto,yearto)
    end
    con.query "SELECT  share.calc_in_out()"
    con.close if con     
else
	loadOneTool(code, fname, dayfrom, monthfrom, yearfrom,dayto,monthto,yearto)
end

