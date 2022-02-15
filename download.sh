###create txtfile for biosamples and projects###
<INSERT PATH 1> list biosamples > biosamples.txt
<INSERT PATH 1> list projects > projects.txt
###make array for project names###i
awk '{print $2}' projects.txt > projectNames.txt
declare -a projectNameList
i=0
x=1
while read -r Line
do
	if [[ "$Line" == *"Name"* ]];then
		x=1
	elif [[ "$Line" == "" ]];then
		x=1
	else
	        projectNameList[i]=$Line
	        let "i+=1"
        fi
done < projectNames.txt
###make array for project id###
awk '{print $4}' projects.txt > projectIDs.txt
declare -a projectIDList
b=0
while read -r Line
do
	if [[ "$Line" == *"Id"* ]];then
		x=1
	elif [[ "$Line" == "" ]];then
		x=1
	else 
		projectIDList[b]=$Line
		let "b+=1"
	fi
done < projectIDs.txt
###make array for biosample name###
awk '{print $2}' biosamples.txt > biosampleNames.txt
declare -a biosampleNamesList
c=0
while read -r Line
do
	if [[ "$Line" == *"BioSampleName"* ]];then
		x=1
	elif [[ "$Line" == "" ]];then
		x=1
	else
		biosampleNamesList[c]=$Line
		let "c+=1"
	fi
done < biosampleNames.txt
###make array for biosample id###
awk '{print $4}' biosamples.txt > biosampleIDs.txt
declare -a biosampleIDsList
k=0
while read -r Line
do 
	if [[ "$Line" == *"Id"* ]];then
		x=1
	elif [[ "$Line" == "" ]];then
		x=1
	else
		biosampleIDsList[k]=$Line
		let "k+=1"
	fi
done < biosampleIDs.txt

###make array for biosample name in specific project###
echo "Enter project name"
read projectName
echo "Would you like to concatenate?(y/n)"
read response
if [[ "$response" == "y" ]];then
	echo "Would you like to download to pace(y/n)?"
	read response2
	if [[ "$response2" == "y" ]];then
		echo "What is your pace username?"
		read username
	fi
fi
<INSERT PATH 1> list biosamples --project-name=$projectName > "$projectName"biosamples.txt
awk '{print $2}' "$projectName"biosamples.txt > "$projectName"biosampleNames.txt
declare -a projectBiosampleNamesList
z=0
while read -r Line
do
	if [[ "$Line" == *"BioSampleName"* ]];then
		x=1
	elif [[ "$Line" == "" ]];then
		x=1
	else
		projectBiosampleNamesList[z]=$Line
		let "z+=1"
	fi
done < "$projectName"biosampleNames.txt
printf '%s\n' "${projectBiosampleNamesList[@]}"
for ((i=0; i < ${#projectBiosampleNamesList[@]}; ++i)); do
	echo "downloading ... ${projectBiosampleNamesList[i]}"
	<INSERT PATH 1> download biosample -n ${projectBiosampleNamesList[i]} -o ../$projectName
done
cd ../$projectName
echo "Download complete!!!"
###concatenate###
if [[ "$response" == "y" ]];then
	rm *.json
	source <INSERT PATH 2>/concatenate.sh
	if [[ "$response2" == "y" ]];then
		scp -r *.fastq* <INSERT PATH 3>
	fi
fi
echo "DONE"
