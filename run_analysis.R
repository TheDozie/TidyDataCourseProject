## read data sets
features<-read.table("features.txt")
## head(features) ##DEBUG##
names(features)<- c("featureNo","featureDescr")
## head(features) ##DEBUG##
activities<-read.table("activity_labels.txt")
## head(activities) ##DEBUG##
names(activities)<- c("activityNo","activity")
## head(activities) ##DEBUG##

## we want to keep only the columns with feature description containing the strings
##      "mean()"
##      "std()"
## get these activity numbers = column numbers
## sort to retain the sequential order and ensure compatibility between training and test data sets
tokeep<-c(grep("mean()", features$featureDescr, fixed=TRUE), 
          grep("std()",features$featureDescr, fixed=TRUE))
tokeep<-sort(tokeep)
## length(tokeep) ##DEBUG##

## transform the descriptions to be more meaningful
features<-transform(features, featureDescr = sub("Acc", "-accelerometer", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("Gyro", "-gyroscope", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("mean()", "mean", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("std()", "stdDev", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("tBody", "time-body", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("fBody", "frequency-body", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("tGravity", "time-gravity", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("fGravity", "frequency-gravity", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = gsub("-", "_", featureDescr, fixed=TRUE))

xtest<-read.table("X_test.txt")
names(xtest)<-features$featureDescr
## keep only columns of mean and std
xtest<-xtest[,tokeep]
## nrow(xtest) ##DEBUG##
## ncol(xtest)

## str(xtest) ##DEBUG##
ytest<-read.table("y_test.txt")
names(ytest)<-"activityNo"
## nrow(ytest) ##DEBUG##
subject_test<-read.table("subject_test.txt")
## nrow(subject_test) ##DEBUG##
names(subject_test)<-"subjectNo"
## each record in xtest matches corresponding rows in:
##      ytest = activity number 
##      subject_test = subject number
##  append them column-wise with cbind - append activity description first
ytest<-transform(ytest,activityDescr=activities[activityNo,2])
full_test<-cbind(subject_test,cbind(activity=ytest$activityDescr,xtest))
## full_test[1:2,1:5] ##DEBUG##

xtrain<-read.table("X_train.txt")
names(xtrain)<-features$featureDescr
xtrain<-xtrain[,tokeep]
## nrow(xtrain) ##DEBUG##
## ncol(xtrain) ##DEBUG##
## str(xtrain) ##DEBUG##
ytrain<-read.table("y_train.txt")

names(ytrain)<-"activityNo"
subject_train<-read.table("subject_train.txt")

names(subject_train)<-"subjectNo"
## nrow(subject_train) ##DEBUG##

## each record in xtrain matches corresponding rows in:
##      ytrain = activity number
##      subject_train = subject number
##  append them column-wise with cbind
ytrain<-transform(ytrain,activityDescr=activities[activityNo,2])
full_train<-cbind(subject_train,cbind(activity=ytrain$activityDescr,xtrain))
## full_train[1:2,1:5] ##DEBUG##

## combine test and training data
combined<-rbind(full_train,full_test)

## we don't need the subject numbers in column 1
tidy_data=combined[, -1]
## but write out the corresponding subjects - like in the supplied datasets
write.table(combined$subjectNo,file="subject_tidy.txt",row.names=FALSE,col.names=FALSE,quote=FALSE,sep="\n")

## tidy_data[1:2,1:4] ##DEBUG##

library(reshape2)
tidy_names<-names(tidy_data) ## extract the variable names
tidy_id<-tidy_names[1] ## the activity labels against which the means are required are in column 1
tidy_vars<-tidy_names[-1] ## remove column 1 to get the variables
tidy_melt<-melt(tidy_data,measure.vars=tidy_vars,id=tidy_id)
tidy_mean<-dcast(tidy_melt, activity ~ variable, mean)
tidy_names<-names(tidy_data)

tidy_features<-data.frame(featureID=1:(length(tidy_names)-1),featureDescr=tidy_names[2:length(tidy_names)])
write.table(tidy_features,file="tidy_features.txt",row.names=FALSE,col.names=FALSE,quote=FALSE,sep=" ")
x_tidy<-tidy_data[,-1] ## exclude the activity names in column 1
## But write out corresponding activity numbers in correct row order -- like supplied dataset
## merge() not used because it will re-order records
y_tidy<-data.frame(activity=tidy_data[,1])
for (i in 1:(nrow(y_tidy))){
      y_tidy$activityNo[i]<-grep(y_tidy$activity[i],activities$activity)
}
# head(y_tidy) ##DEBUG##
library(gdata)
write.table(y_tidy$activityNo,file="y_tidy.txt",row.names=FALSE,col.names=FALSE,quote=FALSE,sep="\n")
write.fwf(x_tidy,
          file="x_tidy.txt",
          rownames=FALSE,
          colnames=FALSE, 
          quote=FALSE, 
          width=15,
          sep=" ")

x_mean<-tidy_mean[,-1] ## exclude the activity names in column 1
## but write out corresponding activity numbers in row order of dataset
z_tidy<-data.frame(activity=tidy_mean[,1])
for (i in 1:(nrow(z_tidy))){
      z_tidy$activityNo[i]<-grep(z_tidy$activity[i],activities$activity)
}
write.table(z_tidy$activityNo,file="y_mean.txt",row.names=FALSE,col.names=FALSE,quote=FALSE,sep="\n")
write.fwf(x_mean,
          file="x_mean.txt",
          rownames=FALSE,
          quote=FALSE, 
          colnames=FALSE, 
          width=15,
          sep=" ")
