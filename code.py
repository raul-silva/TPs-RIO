import subprocess
import time
from threading import Thread


def node(string,i,sleep_t=1,n=10,n_pck = 1):
    '''General function that executes the information collecting process
       of the node i.
       string: string that contains the command
       i: index to identify the node
       sleep_t: sleeping time of the node
       n: number of iterations
       n_pck = number of packets receied
    '''

    sum = 0 #sum of the delays
    init_time = time.time() #initial time
    for k in range(1,n+1,1):
        t1 = time.time() #reference time
        #try:
        result = subprocess.check_output(string, shell=True)
        #except:
        #print "\n\n\n\n====  Error ===\n\n\n\n"
        delay = time.time() - t1
        print "========== Node %d - Step %d - t = %f ==========" % (i,k,sleep_t)
        print "Light: %s" % (result)
        sum += delay
        time.sleep(sleep_t)
    total_time = time.time() - init_time #total time of the process
    avr_delay = sum/n
    print  "%d. Delay = %.4f" % (i,avr_delay)


def test (strings,sleep_t=1,n=10,n_pck = 7):
    '''Function that runs the test in multiple nodes.
       strings: list with strings in the format command + server
    '''

    for i in range(len(strings)):
        t = Thread(target=node, args=(strings[i],i+1,sleep_t,n,n_pck) )
        t.start()



#-------------------------------------------------------------------------
#------------------------------- COAP ------------------------------------
#-------------------------------------------------------------------------


n_pck = 1
command = "coap get "
nodes_uid = ["8578","8570","b983","a777"]
port = ":5683"
output = "/sensors/light"

strings = [] #list with commands for each node

for uid in nodes_uid:
    coap_server = "coap://[2001:660:5307:315d::%s]" % uid
    strings.append(command + coap_server + port + output)


#--------------------------------------------------------------------------
#--------------------------------- HTTP -----------------------------------
#--------------------------------------------------------------------------

'''
n_pck = 7
command = "lynx -dump "
nodes_uid = ["8578"]

strings = [] #list with commands for each node

for uid in nodes_uid:
    http_server  = "http://[2001:660:5307:315d::%s]" % uid
    strings.append(command + http_server)
'''

#--------------------------------------------------------------------------
#--------------------------- Data Collecting ------------------------------
#--------------------------------------------------------------------------

test(strings,1,20,n_pck)









