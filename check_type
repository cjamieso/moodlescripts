#!/bin/bash

if git log --oneline -1 | grep analytics ; then
	echo 'analytics'
elif git log --oneline -1 | grep mail ; then
	echo 'mail'
elif git log --oneline -1 | grep skills_group ; then
	echo 'sg'
elif git log --oneline -1 | grep nurs_navigation ; then
	echo 'nn'
else
	echo 'Did not find a project trigger to test.';
fi

