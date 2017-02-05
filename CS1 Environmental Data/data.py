"""
   Author: Eric Lawson | lawsoe@rpi.edu
   
   Purpose: This program prints environmental info for a given month from the file "tempdata.json" in a 
   readable way. It prints this data for the top 3 years for each statistic, prints the average from the
   first and last ten years, aswell as all years, and creates a histogram of the averages. 
   
"""
import json

## finds stats for given key, return string 
def find_stats(data,key,month):
    
    ## returns string for EMXT,DT90,DX32
    if key == "EMXT" or key == "DT90" or key == "DX32":
        
        ## sets prefix
        if key == "EMXT":
            name = "Highest max  value"
        elif key == "DT90":
            name = "Highest days with max >= 90"
        elif key == "DX32":
            name = "Highest days with max <= 32"
        
        ## creates list of stats    
        stats = []
        for i in range(len(data)):
            if data[i]["month"] == int(month) and data[i][key] != 0 and data[i][key] != -9999:
                stats.append((float(data[i][key]),data[i]["year"]))
        stats.sort(reverse = True)
        
        ## returns stats
        if len(stats) < 3:
            return name + " => Not enough data"
        return "%s => %d: %.1f, %d: %.1f, %d: %.1f" \
               %(name,stats[0][1],stats[0][0],stats[1][1],\
               stats[1][0],stats[2][1],stats[2][0])
    
    ## returns string for EMNT
    if key == "EMNT":
        
        ## creates list of stats
        stats = []
        for i in range(len(data)):
            if data[i]["month"] == int(month) and data[i][key] > 0 and data[i][key] != -9999:
                stats.append((float(data[i][key]),data[i]["year"]))
        stats.sort()
        
        ## returns stats
        if len(stats) < 3:
            return "Lowest min value => Not enough data"
        return "Lowest min value => %d: %.1f, %d: %.1f, %d: %.1f" \
               %(stats[0][1],stats[0][0],stats[1][1],\
               stats[1][0],stats[2][1],stats[2][0])
    
    ## returns string for TPCP,TSNW
    if key == "TPCP" or key == "TSNW":
        
        ## sets prefixes
        if key == "TPCP":
            name1 = "Highest total"
            name2 = "Lowest total"
        elif key == "TSNW":
            name1 = "Highest snow depth"
            name2 = "Lowest snow depth"
        
        ## creates low stats
        low_stats = []
        for i in range(len(data)):
            if data[i]["month"] == int(month) and data[i][key] > 0 and data[i][key] != -9999:
                low_stats.append((float(data[i][key]),data[i]["year"]))
        low_stats.sort()
        
        ## creates high stats
        high_stats = []
        for i in range(len(data)):
            if data[i]["month"] == int(month) and data[i][key] > 0 and data[i][key] != -9999:
                high_stats.append((float(data[i][key]),data[i]["year"]))
        high_stats.sort(reverse = True)
        
        ## returns stats
        if len(low_stats) < 3:
            low_stats_out = name1 + " => Not enough data"
        if len(high_stats) < 3:
            high_stats_out = name2 + " => Not enough data"
        else:   
            high_stats_out = "%s => %d: %.1f, %d: %.1f, %d: %.1f" \
                             %(name1,high_stats[0][1],high_stats[0][0],high_stats[1][1],\
                             high_stats[1][0],high_stats[2][1],high_stats[2][0])
            low_stats_out = "%s => %d: %.1f, %d: %.1f, %d: %.1f" \
                            %(name2,low_stats[0][1],low_stats[0][0],low_stats[1][1],\
                            low_stats[1][0],low_stats[2][1],low_stats[2][0])        
        
        return high_stats_out + "\n" + low_stats_out
    
    ## returns string for MNTM
    if key == "MNTM":
        
        ## creates list of years and temps
        years = []
        for i in range(len(data)):
            if data[i]["month"] == int(month) and data[i][key] > 0 and data[i][key] != -9999:
                years.append((data[i]["year"],data[i]["MNTM"]))
        
        ## calculates avg for all years 
        avg = 0
        for i in range(len(years)):
            if years[i][1] <= 0:
                continue
            avg += years[i][1]
        avg /= len(years)
        avg_out = "Overall: %.1f" %(avg)
        
        ## calculates avg for first 10 years
        years.sort()
        first_avg = 0
        for i in range(10):
            if years[i][1] <= 0:
                continue
            first_avg += years[i][1]
        first_avg /= 10
        first_avg_out = "First 10 years: %.1f" %(first_avg)
        
        ## calculates avg for last 10 years
        years.sort(reverse = True)
        last_avg = 0
        for i in range(10):
            if years[i][1] <= 0:
                continue
            last_avg += years[i][1]
        last_avg /= 10
        last_avg_out = "Last 10 years: %.1f" %(last_avg)
        
        return "%s\n%s\n%s" %(avg_out,first_avg_out,last_avg_out)

## creates histogram    
def make_gram(data,month):
    
    ## creates list of years and temps
    out = ""
    years = []
    for i in range(len(data)):
        if data[i]["month"] == int(month):
            years.append((data[i]["year"],data[i]["MNTM"]))
    years.sort()
    
    ## calculates avg for all groups of 10 years
    avg = 0
    place = 0
    for i in range(len(years)):
        if years[i] <= 0:
            continue
        avg += years[i][1]
        if (i+1)%10 == 0:
            avg = int(avg / 10)
            out += "\n%d-%d: " %(years[i-9][0],years[i][0]) + "*"*avg
            avg = 0
        place += 1
    
    ## calculates avg for remaining years        
    diff = place%10
    for i in range(place,len(years)):
        if years[i] <= 0:
            continue
        avg += years[i][1]
    avg = int(avg / diff)
    out += "\n%d-%d: " %(years[len(years)-diff][0],years[len(years)-1][0]) + "*"*avg

    return out
            

if __name__ == "__main__":
    data = json.loads(open("tempdata.json").read())
    
    month = raw_input("Enter a month (1-12) => ")
    print month
    
    ## creates dictionary of all stats
    stats = {}
    keys = ["EMXT","EMNT","DT90","DX32","TPCP","TSNW","MNTM"]
    for key in keys:
        stats[key] = find_stats(data,key,month)
            
    ## prints all info using dictionary
    print "Temperatures"
    print "-"*50
    print stats["EMXT"]
    print stats["EMNT"]
    print stats["DT90"]
    print stats["DX32"]
    print "\nPrecipitation"
    print "-"*50
    print stats["TPCP"]
    print stats["TSNW"]
    print "\nAverage temperatures"
    print "-"*50
    print stats["MNTM"]
    print make_gram(data,month)
    
    
    
    
    
        
    