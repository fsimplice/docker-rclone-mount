#!/usr/bin/env bash

declare -A versions
#    [amd64/alpine]='alpine:3.6 alpine:3.7 alpine:latest'
#    [amd64/debian]='elfabio972/baseimage-s6:debian_stretch_amd64 elfabio972/baseimage-s6:debian_stretch-slim_amd64 elfabio972/baseimage-s6:debian_stable-slim_amd64'

versions=(
    [amd64/alpine]="\
        elfabio972/baseimage-s6:alpine_latest_amd64 \
        elfabio972/baseimage-s6:alpine_3.6_amd64 \
        elfabio972/baseimage-s6:alpine_3.7_amd64 \
    "
    [amd64/debian]="\
        elfabio972/baseimage-s6:debian_stretch_amd64 \
        elfabio972/baseimage-s6:debian_stretch-slim_amd64 \
        elfabio972/baseimage-s6:debian_stable_amd64 \
        elfabio972/baseimage-s6:debian_stable-slim_amd64
    "
)

declare -A patterns
patterns=(
    [__BASE__]='${version}'
    [__FROM__]='${from}'
    [__DIST__]='${dist}'
    [__IMAGE_TAG__]='${image_tag}'
    [__ARCH__]='${arch}'
)

function build_sed_args {
    result=" "
    for pattern in ${!patterns[*]};do
        variable=${patterns[${pattern}]}
        eval value=$variable
        result+=" -e s#${pattern}#${value}#g"
    done
    echo ${result}
}

function install_template {
    #https://stackoverflow.com/a/965072
    tpl_file=$(basename ${1})
    to_file="${2}"
    if [ -z ${to_file} ]
    then
        to_file="${tpl_file%.*}"; #tpl file without extension as default
    fi
    SED_ARGS=$(build_sed_args)
    #echo "tpl_file: $tpl_file, to_file: $to_file, SED_ARGS: $SED_ARGS"
    sed -e ${SED_ARGS} ${1} > ${dockerfileDirectory}/${to_file}
    chmod a+x ${dockerfileDirectory}/${to_file}
}

for arch_dist in ${!versions[*]}; do
    for version in ${versions[${arch_dist}]};do
        arch=${arch_dist%/*}
        dist=${arch_dist#*/}
        tag=$(echo "${version}" | cut -d ":" -f2 | cut -d "_" -f2)
        image_tag=$(echo "${dist}_${tag}")
        dockerfileDirectory="${dist}/${arch}/${tag}"
        
        echo "> arch: $arch, dist=$dist, tag=$tag, image_tag=$image_tag"

        #Install rootfs
        mkdir -p ${dockerfileDirectory}
        cp -r -f rootfs ${dockerfileDirectory}
                
        #Install Dockerfile
        if [ -e "Dockerfile-${dist}.tpl" ];
        then
            echo "Using Dockerfile-${dist}.tpl for dist='${dist}', arch='${arch}', tag='${tag}'"
            install_template Dockerfile-${dist}.tpl Dockerfile
        else
            echo "Using Dockerfile.tpl for dist='${dist}', arch='${arch}', tag='${tag}'"
            install_template Dockerfile.tpl Dockerfile
        fi
        
        #Install build.sh
        install_template templates/build.sh.tpl

        #Install run.sh
        install_template templates/run.sh.tpl

        #Install test.sh
        install_template templates/test.sh.tpl
    done
done

