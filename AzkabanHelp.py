#!/usr/bin/env python
#coding=utf-8
import sys,datetime,json,os
from imp import reload

import requests


defaultencoding = 'utf-8'
if sys.getdefaultencoding() != defaultencoding:
    reload(sys)
    sys.setdefaultencoding(defaultencoding)


class AzkabanHelp():

    def __init__(self,projectName,targetBaseDir):
        self.azkabanUrl = "http://azkaban.com" #azkban 地址
        self.azkbUser = "" # azkban用户名
        self.azkbPwd = "" #密码
        self.sessionid = ""
        self.projectName = projectName
        self.targetBaseDir = targetBaseDir
    def authLogin(self) :
        params = "action=login&username="+self.azkbUser+"&password="+self.azkbPwd
        headers = {"Content-Type": "application/x-www-form-urlencoded"}
        r = requests.post(self.azkabanUrl,data=params,headers=headers)

        jsonOB = json.loads (r.text)
        if r.status_code == 200 and jsonOB['status'] == "success" :
            self.sessionid = jsonOB['session.id']

    def uploadZip(self):
        self.authLogin()
        zipName = self.projectName+".zip"

        zip = open( self.targetBaseDir+"/"+self.projectName+"/"+zipName, "rb").read()
        files = {
            "file" : (zipName,zip,"application/zip"),
        }
        if self.sessionid.strip() != "" :
            data = {
                "session.id": self.sessionid,
                "ajax":"upload",
                "project":self.projectName
            }
            r = requests.post(self.azkabanUrl+"/manager", data=data, files=files)
            if r.status_code == 200 :
                projectId = json.loads(r.text)['projectId']
                version = json.loads(r.text)['version']
                nowTime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                print ("Upload Succeed ProjectName is %s ProjectID is %s Version: %s TIME:%s" \
                      % (self.projectName,projectId,version,nowTime))


if __name__ == '__main__':
    baseDir = os.path.dirname(os.path.realpath(__file__))
    targetBaseDir = baseDir+"/target"
    azh = AzkabanHelp( sys.argv[1],targetBaseDir )
    azh.uploadZip()





