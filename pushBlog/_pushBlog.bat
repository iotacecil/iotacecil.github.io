call cd ../
call echo %cd%
call echo %cd%

call coscmd upload -rs %cd%\static\images /image
call hexo g -d
call git fetch
call git merge
call git add .
call git commit -m"windows自动提交定时任务"
call git push

