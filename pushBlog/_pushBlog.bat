call D:
call cd D:\iotacecil.github.io

call coscmd upload -rs D:\iotacecil.github.io\static\images /image
call hexo g -d
call git fetch
call git merge
call git add .
call git commit -m"windows�Զ��ύ��ʱ����"
call git push

