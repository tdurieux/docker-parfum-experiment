# http://registry.suse.de/
FROM registry.suse.de/suse/containers/sle-server/12-sp5/containers/suse/sles12sp5:latest AS base

RUN rpm -e container-suseconnect
RUN zypper -n ar -G http://download.suse.de/ibs/SUSE:/SLE-12:/GA/standard/SUSE:SLE-12:GA.repo
RUN zypper -n ar -G http://download.suse.de/ibs/SUSE:/SLE-12:/Update/standard/SUSE:SLE-12:Update.repo
RUN zypper -n ar -G http://download.suse.de/install/SLP/SLE-12-SP5-Server-GM/$(rpm -E %_arch)/DVD1/ DVD1
RUN zypper -n ar -G http://download.suse.de/install/SLP/SLE-12-SP5-Server-GM/$(rpm -E %_arch)/DVD2/ DVD2
RUN zypper -n ar -G http://download.suse.de/install/SLP/SLE-12-SP5-Server-GM/$(rpm -E %_arch)/DVD3/ DVD3
# RUN zypper -n ar -G http://updates.suse.de/SUSE/Products/SLE-SDK/12-SP5/$(rpm -E %_arch)/product/ SDK