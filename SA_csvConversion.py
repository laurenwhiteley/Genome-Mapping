### Import fnmatch module to support Unix shell-style wildcards(these are symbols that take the place of an unknown character or characters(like the *)) ###
import fnmatch 

### Import os module to use operating system dependent functionality ###
import os

### Creates a list of featureCounts files to count ###
featureCountsFiles = []
for file in os.listdir("."):
    if fnmatch.fnmatch(file, "featurecounts_SA*.txt"):
        featureCountsFiles.append(file)
featureCountsFiles.sort()

### Creates list of cutadapt files to count ##
cutadaptFiles = [] 
for file in os.listdir("."):
    if fnmatch.fnmatch(file, "*cutadapt_log.txt"):
         cutadaptFiles.append(file)
cutadaptFiles.sort()

### Creates list of bowtie files to count ### 
bowtieFiles = []
for file in os.listdir("."): 
    if fnmatch.fnmatch(file, "SA*.bowtie_output.txt"):
        bowtieFiles.append(file)
bowtieFiles.sort()

### Creates a list of filenames ###
filenames = []
for i in cutadaptFiles:
    f = i.strip()
    filenames.append(f.replace('_22bp.cutadapt_log.txt', ''))
filenames.sort()
### Creates output csv template
import csv
#summary_basename = input("Count Summary File Name:  ___.csv   ")
#csvfile = open("{}.csv".format(summary_basename), "w")
full_path = os.getcwd().split("/")
projectName = full_path[len(full_path)-1]
summary_basename = "SA_" + projectName + ".csv"
csvfile = open( summary_basename, 'w')
csvfile.write("Sample, Raw Reads, Reads Written, Overall Allignment, Percent Covered, Mean Coverage, Reads Assigned to features, Features with non-zero reads\n") 



### Opens cutadapt txt files and saves number of raw reads and reads written ###
rawReadsList = []
readsWrittenList = []
for file in cutadaptFiles:
    f = open(file, "r")
    lineone = f.readline()
    linetwo = f.readline()
    linethree = f.readline()
    linefour = f.readline()
    linefive = f.readline()
    linesix = f.readline()
    lineseven = f.readline()
    lineeight = f.readline()
    strip = lineeight.strip()
    space = strip.replace(' ', '')
    words = space.replace('Totalreadsprocessed:', '')
    rawReads = words.replace(',', '')
    rawReadsList.append(rawReads)
    linenine = f.readline()
    lineten = f.readline()
    lineeleven = f.readline()
    string = lineeleven.strip()
    spac = string.replace(' ', '')
    word = spac.replace('Readswritten(passingfilters):', '')
    readsWritten = word.replace(',','')
    readsWrittenList.append(readsWritten) 
    f.close()

### Opens bowtie txt files and saves overall allignment and reads not mapped to decoy ###
#notMappedtoDecoyList = []
overallAlignmentList = []
for file in bowtieFiles:
    f = open(file, "r")
    lineone = f.readline()
    linetwo = f.readline()
    #strip = linetwo.strip()
    #notMappedtoDecoy = strip.replace(' reads; of these:', '')
    #notMappedtoDecoyList.append(notMappedtoDecoy)
    linethree = f.readline()
    linefour = f.readline()
    linefive = f.readline()
    string = linefive.strip()
    onetime = string.split(' ')
    linesix = f.readline()
    stringy = linesix.strip()
    moreone = stringy.split(' ')
    alligned = int(moreone[0]) + int(onetime[0])
    overallaligned = str(alligned)
    overallAlignmentList.append(overallaligned)

### Puts data for mean coverage into a list ###
meanCoverageList = []
with open("SA_meanCoverage.txt", "r") as a_file:
    for line in a_file:
        meanCoverage = line.replace('\n', '')
        meanCoverageList.append(meanCoverage)

### Puts data for percent coverage into a list ###
percentCoverageList = []
with open("SA_percentCoverage.txt", "r") as a_file:
    for line in a_file:
        percentCoverage = line.replace('\n', '')
        percentCoverageList.append(percentCoverage)


### Opens featureCounts txt files and saves info to 'data' variable ###
alignmentCountList = []
geneCountList = []
for file in featureCountsFiles:
    f = open(file, "r") 
    topComment = f.readline()
    header = f.readline()
    data = f.readlines()
    f.close()


    ### Reformats txt file data into list of strings ###
    headerStrip = header.strip("\n")
    headerList = headerStrip.split("\t") 
    sampleFiles = headerList[6:]

    dataList = []
    for line in data:
        lineStrip = line.strip("\n")
        lineList = line.split("\t") 
        dataList.append(lineList)

    ### Creates dictionaries with samples as keys ###
    alignmentCount = {}
    geneCount = {}

    for sample in sampleFiles:
        alignmentCount[sample] = 0
        geneCount[sample] = 0

    ### Counts reads and genes ###
    for data in dataList:

     if len(data) >= 7:
            for index,element in enumerate(data):
                if index>=6: 
                    num_reads = int(element)
                    sample_match = sampleFiles[index - 6]

                    alignmentCount[sample_match] += num_reads
                    if num_reads != 0: 
                        geneCount[sample_match] += 1 

    for sample in sampleFiles: 
        alignmentCountList.append(alignmentCount[sample])
        geneCountList.append(geneCount[sample])

    ### Adds counts to csv file ###  
   # for sample in sampleFiles: 
       # csvfile.write("{0},{1},{2},{3},{4},{5},{6},{7},{8}".format('','','','','','','',alignmentCount[sample],geneCount[sample])) 
### Adds data to csv file ###
i = 0
for file in cutadaptFiles:
    csvfile.write ("{0},{1},{2},{3},{4},{5},{6},{7}\n".format(filenames[i], rawReadsList[i], readsWrittenList[i], overallAlignmentList[i], percentCoverageList[i], meanCoverageList[i], alignmentCountList[i], geneCountList[i]))

    i = i + 1

csvfile.close()
