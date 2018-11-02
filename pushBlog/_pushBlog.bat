call D:
call cd D:\iotacecil.github.io

call hexo qiniu sync
call hexo g -d
call git fetch
call git merge
call git add .
call git commit -m"windows自动提交定时任务"
call git push

