call cd ../
call echo %cd%
call echo %cd%

call coscmd download -rs /image %cd%\static\images 
call coscmd upload -rs %cd%\static\images /image
call git fetch
call git merge
call git add .
call git commit -m"windows自动提交定时任务"
call hexo g -d
call git push
call hexo g -d

