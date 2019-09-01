# z390

GitHub instance of Z390 ( http://sourceforge.net/projects/z390/files/z390_v1506/ ), forked from marksalter/z390.

## compile _Java_ code

```sh
cd path/to/z390/src
javac -g:none *.java \
  && jar cmf Z390.MAN z390.jar *.class
```
