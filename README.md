# Jin

Jin is a Java package that compiles and executes java code. The programs operate much like OS shell scripting. Except for a few custom commands and structures, Jin is Java and supports any Jdk from 1.3 to 9. A properly configured Jin environment will run on any OS supporting Java.

## Installation

 1\. After downloading the Github zip file, select an install directory and extract the contents.

```
jin-0.1.0
├── bin
│   ├── J9Mod
│   ├── jin.properties
│   ├── jlin
│   └── jwin.cmd
├── classes
├── lib
│   ├── derby.jar
│   ├── derbytools.jar
│   ├── fscontext.jar
│   ├── jin
│   │   ├── jin9.jar
│   │   └── jin.jar
│   └── providerutil.jar
├── scripts
│   ├── DerbyDemo
│   ├── jin.properties
│   ├── Next
│   ├── next2
│   ├── PrintEnv
│   ├── run_on_date.sh
│   └── TestIt
└── src
    └── module-info.java
```

2\. Adding to PATH Configuration:

* Add the __scripts__ and __bin__ directories to your PATH variable.
* Make sure you have a Java JDK installed and the JAVA_HOME system variable is set.

## Test Install

>On Linux, from any directory, type `TestIt`, on Windows type `jwin TestIt`. If this fails, check that your PATH variable is set properly.

* You should see; `******* Output from TestIt *******`.

>If the __PATH__ setup fails or you wish not to set the __PATH__, you can run Jin like this;
>
* The Linux command for Jin is `jlin` and for Windows `jwin`.
>
> `<install dir>/jin-0.1.0/bin/jlin <install dir>/jin-0.1.0/scripts/TestIt` or `<install dir>\jin-0.1.0\bin\jwin <install dir>\jin-0.1.0\scripts\Testit`
>
>
>On Windows the PATH setup does not work without additional configuration. To run like a `cmd` file you must add an extension to all of the main scripts, e.g. `TestIt.jin` and then associate the jin extension to the Jin jwin command script in the bin directory. Refer to your Windows documentation on the procedure.
>
>__Note__; On Windows after putting both the `<install dir>\jin-0.1.0\bin` and `<install dir>\jin-0.1.0\scripts` on the PATH, you would normally run like this; `jwin TestIt` from any directory.
>
>On Windows10, if you have a WSL `bash` feature installed, you can execute as if you're on Linux.

## Additional Setup

>There are three important system variables.

* JAVA_HOME - Jin will find the java executable here
* JIN_HOME - Where the Jin `bin` and `lib` dirs reside
* JIN_APP - Where the `scripts` and `classes` dirs reside

>The JAVA_HOME variable must be set, however, under most circumstances JIN_HOME and JIN_APP will be set internally.
>
>Since the install and application use different environment variables, you can move the JIN_APP directory to a more appropriate location. Just make sure your PATH knows about the new location, i.e. append `<new location>/scripts` to the PATH. Also, scripts can have any file name extension except __.java__.

* You can use custom or vendor jars by adding them to the __lib__ directory.
* Inline classes can be added to the script.

## Jin custom commands and variables

* `tout` - `System.out.print`
* `lout` - `System.out.prntln`
* `tin` - `System.in`
* `host("command")` - runs an OS command.  You can control the sys out and the err out.  See the script "Next" in the scripts directory.
* `!<script> <optional parameters> lr=false` - dynamically compile, load and run a nested script, e.g. `!Next "param1" "param2"`
* `!<package>.<script> <optional parameters> lr=true` - load and execute a pre-compiled script(a script run dynamically at least once).
* `!3` - will run the class associated with key=3(jin.properties), this is legacy and it's better to use a string key.
* `!"NextTest" "param1" "param2"` - will run the named key associated to a class, see jin.properties file.
* `Hashtable h` - Jin converts args[] to this Hashtable.
* `(String)h.get("$1")` retrieves the first standalone(without an "=" or "~") parameter. Params that have '=' or '~' are saved as key, value.  Standalone parameters are stored as $n keyed values.  For example: TestIt dir cd=. -d  would produce Hashtable entries(key,value)as ("$1", "dir"); ("CD", "."); ("$2", "-d").
* If a script attempts to retrieve a standalone value and it's not found in the Hashtable, Jin will ask for a value. If the script asks for "$0" `(String)h.get("$0")`, Jin will always ask for a value. To check the Hashtable for a numbered key without forcing a prompt if not found, use a variable equal to (char)0x24 in place of the "$".
* To pass collections of data among scripts there is a global Hashtable `passData`.
* `!echo` can echo executing code, however it does have issues and should be used carefully.
>* This should work; (block code must start on the same line as the command)

```java
        if(test) { ....
```

>* This would fail;

```java
        if(test)
        { ....
```

* Interfaces can be added to the script class with the keyword __interface__ following the imports, e.g.,

```java
        import java.sql.*;
        interface MyFirstInterface, MySecondInterface;
```

## Nesting scripts

* Main scripts on Linux use the shell `env` to run Java.  Therefore the first line of the script must be; `#!/usr/bin/sh env jlin` assuming that the .../jin-0.1.0/bin directory is in your path, this is default. The `env jlin` can be changed to `env <dirctory to bin>/jlin` if needed.
* For subscripts the `env` setup is optional, a subscript can be executed directly with this form; `jlin <scriptname>`, e.g. `jlin next2 dir myname`.
* To run a subscript from another script use `!<scriptname> <parameters>` as explained above.

## Special parameters and jin.properties

> There are three special parameter types;
1. Internal Jin parameters
1. Keyed values located in jin.properties
1. User command line parameters
* Internal
    1. CD - Classpath to Jin generated classes
    1. CO - Java Command Line Option, e.g. -X
    1. PK - Script package
    1. SR - Source Script Name
    1. CN - Generated script.java file.
    1. WD - The script directory
* jin.properties
    1. User command line parameters can also reside as defaults in the jin.properties file.  Jin will look for the file in the current directory, if not found, will look in the scripts directory.
* User set parameters
    1. CP - Compile script only, false,true, default false.
    1. LR - Load and Run the class, false,true, default false.
    1. BP - Java9, bypass the module system, true,false, default false.
    1. DP - Java -D parameter
    1. $DS - Delete generated java source.  On the command line the $ must be escaped, e.g. to keep generated java source code; `\$DS=false`, default true.

    __Important__; On windows parameters must be enclosed in double quotes with a leading space if using '=' as the delimiter, e.g., `jwin TestIt " CP=true myparm=stuff"`. Alternatively, you can use '~' as the delimiter without issue, e.g., `jwin TestIt bp~true cp~true myparm~stuff`.

    __Note__; As mentioned above, you can use system environment variables to override `WD, JIN_HOME and JIN_APP`.

## Java9 and module system

> Jin uses the Java9 module system. By default the modules used are;

```java
module jin.it {
    requires java.base;
    requires java.compiler;
    requires java.logging;
    requires java.sql;
    exports jin.shell;
    exports jin.shell.factory;
}
```

> For additional modules do;

1. add to src/modules-info.java
1. cd to the Jin `bin` directory
1. Linux; export WD=".", Windows; set WD="."
1. execute J9Mod to compile src/modules-info.java and rebuild the jin9.jar file. The jar build uses an extract of jin9.jar at classes/jar.
1. Don't forget to `unset WD` when finished.

    __Important__; On windows the jar is generated as newjin9.jar in the `lib\jin\` directory. Remove the old jin9.jar and rename newjin9.jar to jin9.jar. Windows puts a lock on the jin9.jar file that is being used by J9Mod.

    __Note__; J9Mod runs on both Linux and Windows since it is written in __Jin__;
