import logging, time, io
from ipdi.ip.pyaip import pyaip, pyaip_init

## IP Dummy driver class
class PICORV32:
    ## Class constructor of IP Dummy driver
    #
    # @param self Object pointer
    # @param targetConn Middleware object
    # @param config Dictionary with IP Dummy configs
    # @param addrs Network address IP
    def __init__(self, connector, nic_addr, port, csv_file):
        ## Pyaip object
        self.__pyaip = pyaip_init(connector, nic_addr, port, csv_file)

        if self.__pyaip is None:
            logging.debug(error)

        ## Array of strings with information read
        self.dataRX = []

        ## IP Dummy IP-ID
        self.IPID = 0

        self.__getID()

        self.__clearStatus()
        self.__PICORV32_instruc = []
        logging.debug(f"IP PICORV32 controller created with IP ID {self.IPID:08x}")

    def OpenTxData(self, name):
        # self.name=""
        with io.open(name, 'r') as Data2TxFile:
            line = Data2TxFile.readline()
            while line:
               line = str(line)
               aa = "0x" + line[0:8]
               #print("string numbers")
               print(aa)
               self.__PICORV32_instruc.append(int(aa, 0))
               # print(int(aa,0))
               line = Data2TxFile.readline()
    
    def sendPICORV32_PROG(self):
        data =  self.__PICORV32_instruc
        dataLen = len(self.__PICORV32_instruc)
        print("Lets fullfil MProgramMEMIN")
        if dataLen != 0:
            self.writeData(self.__PICORV32_instruc)
            print("[{}]".format(', '.join(hex(x) for x in data)))
        else:
            logging.debug("There is no PICORV32 instructions")
    ## Write data in the IP Dummy input memory
    #
    # @param self Object pointer
    # @param data String array with the data to write
    def writeData(self, data):
        self.__pyaip.writeMem('MProgramMEMIN', data, len(data), 0)

        logging.debug("Data captured in Mem Data In")

    def resetPICORV32(self):
        self.__pyaip.writeConfReg('CCONFREG', [1], 1, 0)
        time.sleep(0.1)

        
    
    def assertPICORV32(self):
        self.__pyaip.writeConfReg('CCONFREG', [0], 1, 0)
        time.sleep(0.1)

    ## Read data from the IP Dummy output memory
    #
    # @param self Object pointer
    # @param size Amount of data to read
    def readData(self, size):
        data = self.__pyaip.readMem('MDATAOUT', size, 0)
        logging.debug("Data obtained from Mem Data Out")
        return data

    ## Start processing in IP Dummy
    #
    # @param self Object pointer
    def startIP(self):
        self.__pyaip.start()

        logging.debug("Start sent")



    ## Enable IP Dummy interruptions
    #
    # @param self Object pointer
    def enableINT(self):
        self.__pyaip.enableINT(0,None)

        logging.debug("Int enabled")

    ## Disable IP Dummy interruptions
    #
    # @param self Object pointer
    def disableINT(self):
        self.__pyaip.disableINT(0)

        logging.debug("Int disabled")
    
    ## Show IP Dummy status
    #
    # @param self Object pointer
    def status(self):
        status = self.__pyaip.getStatus()
        logging.info(f"{status:08x}")

        ## Show IP Dummy status
        #
        # @param self Object pointer
        def status(self):
            status = self.__pyaip.getStatus()
            logging.info(f"{status:08x}")

    ## Finish connection
    #
    # @param self Object pointer
    def finish(self):
        self.__pyaip.finish()

    ## Wait for the completion of the process
    #
    # @param self Object pointer
    def waitInt(self):
        waiting = True
        
        while waiting:

            status = self.__pyaip.getStatus()

            logging.debug(f"status {status:08x}")
            
            if status & 0x1:
                waiting = False
            
            time.sleep(0.1)

    ## Get IP ID
    #
    # @param self Object pointer
    def __getID(self):
        self.IPID = self.__pyaip.getID()

    ## Clear status register of IP Dummy
    #
    # @param self Object pointer
    def __clearStatus(self):
        for i in range(8):
            self.__pyaip.clearINT(i)

if __name__=="__main__":
    import sys, random, time, os

    logging.basicConfig(level=logging.INFO)
    connector = '/dev/ttyACM0'
    csv_file = 'ID0000200F_PICORV32/ID0000200F_config.csv'
    addr = 1
    port = 0
    aip_mem_size = 8

    try:
        picorv32_module = PICORV32(connector, addr, port, csv_file)
        logging.info("Test PICORV32: Driver created")
    except:
        logging.error("Test PICORV32: Driver not created")
        sys.exit()

    random.seed(1)

    picorv32_module.disableINT()
    
    picorv32_module.resetPICORV32()
    
    picorv32_module.OpenTxData("firmware/altera_out.txt")

    picorv32_module.sendPICORV32_PROG()
    
    picorv32_module.assertPICORV32()
    logging.info(f"PICORV32 starts")


    picorv32_module.startIP()

    #picorv32_module.waitInt()


    picorv32_module.status()

    picorv32_module.finish()

    logging.info("The End")
