call cd ../
call echo %cd%
call echo %cd%

call coscmd upload -rs %cd%\static\images /image
call hexo g -d
call git fetch
call git merge
call git add .
call git commit -m"windows�Զ��ύ��ʱ����"
call git push

