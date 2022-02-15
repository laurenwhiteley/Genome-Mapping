### Import fnmatch module to support Unix shell-style wildwards ###
import fnmatch 


### Import os module to use operating system dependent functionality ###
import os


### Creates a list of files to count ###
coverageFilesList = []
for file in os.listdir("."):
    if fnmatch.fnmatch(file, "SA*_coverage.txt"):
        coverageFilesList.append(file)
coverageFilesList.sort()


### Creates output csv template ###
#import csv
#summary_basename = input("Count Summary File Name:  ___.csv   ")
#csvfile = open("{}.csv".format(summary_basename), "w")

#csvfile.write("Percent coverage,Mean coverage\n")



### Opens coverageFiles and makes lists of percent coverage and mean coverage ###
percentCoverageList = []
meanCoverageList = []
for file in coverageFilesList:
    f = open(file, "r")
    lineone = f.readline()
    linetwo = f.readline()
    linethree = f.readline()
    linefour = f.readline()
    linefive = f.readline()
    strip = linefive.replace(' ','')
    split = strip.split(':')
    percentCoverage = split[len(split)-1].replace('\n', '')
    percentCoverageList.append(percentCoverage)
    linesix = f.readline()
    stripe = linesix.replace(' ','')
    splite = stripe.split(':')
    meanCoverage = splite[len(splite)-1].replace('\n', '')
    meanCoverageList.append(meanCoverage)

### Puts info into txt files ###
percent= open("SA_percentCoverage.txt","w+")
for i in percentCoverageList:
    percent.write(i)
    percent.write('\n')
percent.close()
mean= open("SA_meanCoverage.txt","w+")
for i in meanCoverageList:
    mean.write(i)
    mean.write('\n')
mean.close()

    ### Adds counts to csv file ###
    #for sample in sampleFiles:
        #csvfile.write("{0},{1},{2}\n".format(
            #sample,
            #alignmentCount[sample],
            #geneCount[sample]))

#csvfile.close()
