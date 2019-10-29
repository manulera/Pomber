#!/usr/bin/env bash
for folder in sorted/pos*
do
   mv $folder/* .
   rm $folder/guide.m
done