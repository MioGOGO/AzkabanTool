#!/bin/sh

BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`
BASEDIR_PARENT=${BASEDIR}
BASEDIR=${BASEDIR}/AzkabanTool

#source ${BASEDIR}/env.sh



if [ ! -d "${BASEDIR}/target" ]; then
	mkdir ${BASEDIR}/target
fi


if [ ! -n "$1" ] ;then
    echo "please input azkaban jobname"
    exit
else
	JOBNAME=$1
    if [ -n "$2" ] ;then
        JOBTYPE=$2
    fi
fi

AZKABAN_JON_DIR=${BASEDIR}/bin/AzkabanJob
FULLDIR=${AZKABAN_JON_DIR}/${JOBNAME}

if [ ! -d ${FULLDIR} ]; then
	echo "azkaban job is not exist"
	exit
fi

PROJECT_TARGET_DIR=${BASEDIR}/target/${JOBNAME}

if [ -d ${PROJECT_TARGET_DIR} ]; then
	rm -rf ${PROJECT_TARGET_DIR}
fi

cp -r ${FULLDIR} ${BASEDIR}/target/


if [ ! -d "${PROJECT_TARGET_DIR}" ]; then
	echo "create dir fail"
	exit
fi

cp ${BASEDIR}/conf/*.keytab ${PROJECT_TARGET_DIR}/
cp -r ${BASEDIR}/conf/flow20.project ${PROJECT_TARGET_DIR}/
cp -r ${BASEDIR}/env.sh ${PROJECT_TARGET_DIR}/bin/
cp -r ${BASEDIR}/utils ${PROJECT_TARGET_DIR}/bin/





if [ ! -f "${PROJECT_TARGET_DIR}/${JOBNAME}.zip" ];then
    echo "\033[32m ----Start Zipping---- \033[0m"
else
	rm -f ${PROJECT_TARGET_DIR}/${JOBNAME}.zip
fi

cd ${PROJECT_TARGET_DIR} && zip -r ${JOBNAME}.zip ./*


if [ -f "${PROJECT_TARGET_DIR}/${JOBNAME}.zip" ];then
	echo "\033[32m ---------INFO-------- \033[0m"
	echo "\033[32m ----Build Succeed---- \033[0m"
fi


echo "\033[32m Start uploading to the server \033[0m"


#python ${BASEDIR}/AzkabanHelp.py ${JOBNAME}

echo "\033[32m Completed \033[0m"
