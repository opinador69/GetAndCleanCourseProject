require(data.table)
require(plyr)

data.Dir<-"./UCI HAR Dataset"
out.Dir<-"./UCI HAR Dataset/intData"  # Place to write the intgrated data
test.Dir<-"./UCI HAR Dataset/test"    # test files directory
train.Dir<-"./UCI HAR Dataset/train"  # train files directory

#Read general data info
data.feat<-fread(paste(data.Dir,"features.txt",sep="/"))        # Read variable names
data.acti<-fread(paste(data.Dir,"activity_labels.txt",sep="/")) # Read activity labels
setkey(data.acti,V1)                                            # Set key to activities

#####################################################
# BEGIN Read test info                              #
#####################################################

test.Xset<-fread(paste(test.Dir,"X_test.txt",sep="/"))  # Read test set
names(test.Xset)<-data.feat$V2                          # Assign column names to test set

# Select column names that contain "mean" or "std" in the name
cols<-grep("mean|std",colnames(test.Xset))              

test.ylab<-fread(paste(test.Dir,"y_test.txt",sep="/"))  # Read test labels
setkey(test.ylab,V1)                                    # Set key to test labels
test.sbj<-fread(paste(test.Dir,"subject_test.txt",sep="/")) # Read test subject ids

# combine data using:
# - sbj: Untouched test subject ids
# - labels: The named activities (merging ylab with the activity names table)
# - The subset columns of Xset that contain "mean" or "std" in the column name 

test.full<-data.table(sbj=test.sbj$V1,labels=merge(test.ylab,data.acti,by="V1")$V2
                      ,subset(test.Xset,,cols))

#####################################################
# END Read test info                                #
#####################################################

#####################################################
# BEGIN Read train info                              #
#####################################################

train.Xset<-fread(paste(train.Dir,"X_train.txt",sep="/"))  # Read train set
names(train.Xset)<-data.feat$V2                 # Assign column names to train set

# Select column names that contain "mean" or "std" in the name
cols<-grep("mean|std",colnames(train.Xset))              

train.ylab<-fread(paste(train.Dir,"y_train.txt",sep="/"))  # Read train labels
setkey(train.ylab,V1)                                    # Set key to train labels
train.sbj<-fread(paste(train.Dir,"subject_train.txt",sep="/")) # Read train subject ids

# combine data using:
# - sbj: Untouched train subject ids
# - labels: The named activities (merging ylab with the activity names table)
# - The subset columns of Xset that contain "mean" or "std" in the column name 

train.full<-data.table(sbj=train.sbj$V1,labels=merge(train.ylab,data.acti,by="V1")$V2,
                       subset(train.Xset,,cols))

#####################################################
# END Read train info                                #
#####################################################

# Bind test.full and train.full
listBind<-list(test.full,train.full)
integratedDT<-rbindlist(listBind)

#List the columns to use as "measure vars"
cols2<-colnames(integratedDT)[grep("mean|std",colnames(integratedDT))]
cols2<-as.vector(cols2)
#Melt the data table considering the ids and the measure vars
integratedDT_melt<-melt(integratedDT,id=c("sbj","labels"),measure.vars = cols2)
#Sumarize the data table using the mean as aggregator for all the measure vars
outDT<-dcast(integratedDT_melt,sbj + labels ~ variable,fun.aggregate = mean)

