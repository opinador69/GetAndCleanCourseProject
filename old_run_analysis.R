
data.Dir<-"./UCI HAR Dataset"
out.Dir<-"./UCI HAR Dataset/intData"  # Place to write the intgrated data
test.Dir<-"./UCI HAR Dataset/test"    # test files directory
train.Dir<-"./UCI HAR Dataset/train"  # train files directory

# Read all the names of the files to me merged
#test.DirList<-list.dirs(test.Dir)
#test.Files<-list.files(test.Dir, recursive = TRUE)
#train.Files<-list.files(train.Dir, recursive = TRUE)

# Create the output Dirs if they don't exist
#if (!file.exists(outDir)){
#  dir.create(outDir)
#}
#if (!file.exists(paste(outDir,"/Inertial Signals",sep=""))){
#  dir.create(paste(outDir,"/Inertial Signals",sep=""))
#}

#Read general data info
data.feat<-fread(paste(data.Dir,"features.txt",sep="/"))        # Read variable names
data.acti<-fread(paste(data.Dir,"activity_labels.txt",sep="/")) # Read activity labels
setkey(data.acti,V1)                                            # Set key to activities

#####################################################
# BEGIN Read test info                              #
#####################################################

test.Xset<-fread(paste(test.Dir,"X_test.txt",sep="/"))  # Read test set
names(test.Xset)<-data.feat$V2                          # Assign column names to test set
cols<-grep("mean|std",colnames(test.Xset))              # Select interesting columns
test.ylab<-fread(paste(test.Dir,"y_test.txt",sep="/"))  # Read test labels
setkey(test.ylab,V1)                                    # Set key to test labels
test.sbj<-fread(paste(test.Dir,"subject_test.txt",sep="/")) # Read test subject ids

# combine data using:
# - Untouched test subject ids
# - The named activities (merging ylab with the activity names table)
# - The subset columns of Xset that contain "mean" or "std" in the column name 

test.full<-data.table(sbj=test.sbj$V1,labels=merge(test.ylab,data.acti,by="V1")$V2
                      ,subset(test.Xset,,cols))

#####################################################
# END Read test info                                #
#####################################################


#Read train info
train.Xset<-fread(paste(train.Dir,"X_train.txt",sep="/"))
names(train.Xset)<-data.feat$V2
cols<-grep("mean|std",colnames(train.Xset))
train.ylab<-fread(paste(train.Dir,"y_train.txt",sep="/"))
setkey(train.ylab,V1)
train.sbj<-fread(paste(train.Dir,"subject_train.txt",sep="/"))
train.full<-data.table(sbj=train.sbj$V1,labels=merge(train.ylab,data.acti,by="V1")$V2
                       ,subset(train.Xset,,cols))


for(i in 1:length(testFiles)){
  testAuxFile<-paste(testDir,testFiles[i],sep="/")
  trainAuxFile<-paste(trainDir,trainFiles[i],sep="/")
#  outAuxFile<-paste(outDir,sub("_test","_int",testFiles[i]),sep="/")
#  file.copy(testAuxFile,outAuxFile)
#  file.append(outAuxFile,trainAuxFile)
#  print(c("i=",i,"de ",length(testFiles)))
  testAuxDT<-fread(testAuxFile)
  trainAuxDT<-fread(trainAuxFile)
  listaDT<-list(testAuxDT,trainAuxDT)
  outAuxDT<-rbindlist(listaDT)
#  write.table(testAuxDT,paste(outDir,sub("_test","_int",testFiles[i])))
}