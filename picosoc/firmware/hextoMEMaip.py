#!/usr/bin/env python3

from sys import argv
from os.path import exists

def test():
    with open('firmware/main_aipcop.hex') as f,open('firmware/main_out.txt', 'w') as f_out:
        index=1
        # vector reset FLASH (rx) : ORIGIN = 0x00100000, LENGTH = 0x2000
        addr = '@000'
        for line in f:
            if index>1:
                line = line.strip()
                linea = line
                #print(line)
                #xx = line[0:2]+line[3:5]+line[6:8]+line[9:11]
                if index == 2:
                    #xx ="@0 "+line[9:11]+line[6:8]+line[3:5]+line[0:2]
                    xx =line[9:11]+line[6:8]+line[3:5]+line[0:2]
                    f_out.write(xx+'\n')
                    #print(xx)
                    offset = 12
                    xx = line[offset+9:offset+11]+line[offset+6:offset+8]+line[offset+3:offset+5]+line[offset+0:offset+2]
                    f_out.write(xx+'\n')
                    #print(xx)
                    offset = 12*2
                    xx = line[offset+9:offset+11]+line[offset+6:offset+8]+line[offset+3:offset+5]+line[offset+0:offset+2]
                    f_out.write(xx+'\n')
                    #print(xx)
                    offset = 12*3
                    xx = line[offset+9:offset+11]+line[offset+6:offset+8]+line[offset+3:offset+5]+line[offset+0:offset+2]
                    f_out.write(xx+'\n')
                    #print(xx)
                else:
                    xx =line[9:11]+line[6:8]+line[3:5]+line[0:2]
                    #print('Size line:')
                    #print(len(line))
                    if len(line) == 47:
                        f_out.write(xx+'\n')
                        #print(xx)
                        offset = 12
                        xx = line[offset+9:offset+11]+line[offset+6:offset+8]+line[offset+3:offset+5]+line[offset+0:offset+2]
                        #if line[offset+0:offset+2]==20:
                        	#print('blank space found')
                        f_out.write(xx+'\n')
                        #print(xx)
                        offset = 12*2
                        xx = line[offset+9:offset+11]+line[offset+6:offset+8]+line[offset+3:offset+5]+line[offset+0:offset+2]
                        #if line[offset+0:offset+2]=='  ':
                        #	print('blank space found')
                        f_out.write(xx+'\n')
                        #print(xx)
                        offset = 12*3
                        xx = line[offset+9:offset+11]+line[offset+6:offset+8]+line[offset+3:offset+5]+line[offset+0:offset+2]
                        #if line[offset+0:offset+2]=='  ':
                        #   print('blank space found')
                        f_out.write(xx+'\n')
                        #print(xx)
                    else:    
                        if line[0] == '@':
                            print('find it!')
                            address = addr + line[4:10]
		            #f_out.write(address+'\n')
                            print('address')
                            print(address)
		            
                        if len(line) == 11:
                            f_out.write(xx+'\n')
                            #print(xx)
		            		            
                        if len(line) == 23:
                            f_out.write(xx+'\n')
                            #print(xx)
                            offset = 12
                            xx = line[offset+9:offset+11]+line[offset+6:offset+8]+line[offset+3:offset+5]+line[offset+0:offset+2]
                            f_out.write(xx+'\n')
                            #print(xx)
		            		            
                        if len(line) == 35:
                            f_out.write(xx+'\n')
                            #print(xx)
                            offset = 12
                            xx = line[offset+9:offset+11]+line[offset+6:offset+8]+line[offset+3:offset+5]+line[offset+0:offset+2]
                            f_out.write(xx+'\n')
                            #print(xx)
                            offset = 12*2
                            xx = line[offset+9:offset+11]+line[offset+6:offset+8]+line[offset+3:offset+5]+line[offset+0:offset+2]
                            f_out.write(xx+'\n')
                            #print(xx)
		        
            index = index + 1
	    #print(line[0:2],line[3:5],line[6:8],line[9:11])
	    #line = int(line,16)
	    #f_out.write('{}\n'.format(hex(line)))
    print("done.")

if __name__ == '__main__':
    test()
