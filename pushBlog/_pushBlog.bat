call cd ../
call echo %cd%
call echo %cd%

call coscmd download -rs /image %cd%\static\images 
call coscmd upload -rs %cd%\static\images /image
call git add .
call git commit -m"windows�Զ��ύ��ʱ����"
call git fetch
call git merge
call git add .
call git commit -m"windows�Զ��ύ��ʱ����after merge"
call git push
call hexo g -d

