package main

import (
    "fmt"
    "./scw-api"
    "time"
    "os/exec"
    "os"
    "strings"
    )
    
var allowedIps []string

func main(){
	resetFirewall()
	for {
		check()
		time.Sleep(20 * time.Second)
	}
}


func check() {
	keyAndSecret:=strings.Split(os.Getenv("FWUPD_LOGIN"), ":")
	api, err := scwapi.NewScalewayAPI("https://api.scaleway.com", "https://account.scaleway.com", keyAndSecret[0],keyAndSecret[1])
	if (err != nil){
	    fmt.Println("Error")
	    fmt.Println(err)
	    return
	}
	servers, err := api.GetServers(true,0)
	if (err != nil){
	    fmt.Println("Error")
	    fmt.Println(err)
	    return
	}
	var newIPs []string
	var requiredTag=os.Getenv("FWUPD_TAG")
	for _, serverInfo := range *servers{
	    for _, tag := range serverInfo.Tags {
			if tag == requiredTag {
				newIPs=append(newIPs,serverInfo.PrivateIP)
				newIPs=append(newIPs,serverInfo.PublicAddress.IP)
			}
		}
	}
	if (!testEq(allowedIps,newIPs)){
		for _, IP := range allowedIps{
			unallowIP(IP)
		}
		
		for _, IP := range newIPs{
			allowIP(IP)
		}
		allowedIps=newIPs
	}
}

func testEq(a, b []string) bool {

    if a == nil && b == nil { 
        return true; 
    }

    if a == nil || b == nil { 
        return false; 
    }

    if len(a) != len(b) {
        return false
    }

    for i := range a {
        if a[i] != b[i] {
            return false
        }
    }

    return true
}

func resetFirewall(){
	exec.Command("ufw","--force","reset").Run()
	exec.Command("ufw","default", "allow","incoming").Run()
	exec.Command("ufw","--force","enable").Run()
	openPort("22")
	blockPort("4001")
	blockPort("7001")
	blockPort("2379")
	allowIP("127.0.0.1")
}

func openPort(port string){
	exec.Command("ufw", "allow", port).Run()
}

func blockPort(port string){
	exec.Command("ufw", "deny", port).Run()
}

func allowIP(ip string){
	exec.Command("ufw","insert","1","allow","from",ip).Run()
}

func unallowIP(ip string){
	exec.Command("ufw","--force","delete","allow","from",ip).Run()
}
