import std.stdio;
import std.file;


class ubyteContainer {
    protected ubyte[] dataArray;
    protected uint dataPtr;   

    void decPtr() {
        assert(--dataPtr >= 0);
    }
    
    ubyte getData() {
        return dataArray[dataPtr];
    }
}

class bfCellArray : ubyteContainer {
    this() {
        dataArray = new ubyte[](2);
    }
    
    void incPtr() {
        if (++dataPtr == dataArray.length) {
            dataArray.length = (dataArray.length * 3) / 2;   
        }             
    }
    
    void incData() {
        ++dataArray[dataPtr];
    }      

    void decData() {
        --dataArray[dataPtr];
    }
    
    void putData(in ubyte foo) {
        dataArray[dataPtr] = foo;
    }
}    

class bfCommandArray : ubyteContainer {
    this(in ubyte[] cmdData) {
        dataArray = cmdData.dup;
    }       
    
    bool incPtr() {
        return (++dataPtr != dataArray.length);
    }        
}            

void main(char[][] args) {
    if (2 == args.length) {
        runx(cast(immutable ubyte[])read(args[$-1]));       
    } else {
        writefln("Need 1 command line argument, was supplied %s", args.length - 1);        
    }        
}

void runx(in ubyte[] cmds) {
    auto bfCommands = new bfCommandArray(cmds);
    auto bfCells = new bfCellArray();
    
    for (;;) {
        //auto cmdcur = cast(char)bfCommands.getData();
        //writefln("%s", cmdcur);

        switch (bfCommands.getData()) {
            case cast(ubyte)'>':
                bfCells.incPtr();
                break;

            case cast(ubyte)'<':
                bfCells.decPtr();
                break;

            case cast(ubyte)'+':
                bfCells.incData();
                break;

            case cast(ubyte)'-':
                bfCells.decData();
                break;

            case cast(ubyte)'.':
                writef("%s", cast(char)bfCells.getData());
                break;

            case cast(ubyte)',':
                char fooo;
                readf("%c", &fooo);
                bfCells.putData(cast(ubyte)fooo);
                //writeln("input: Not currently supported");
                break;

            case cast(ubyte)'[':
                if (0 == bfCells.getData()) {
                    int foo = 1; 
                    for (;;) {
                        bfCommands.incPtr();
                        switch (bfCommands.getData()) {
                            case cast(ubyte)'[':
                                foo++;
                                break;
                            case cast(ubyte)']':
                                foo--;
                                break;
                            default:
                        }                          
                        if (0 == foo) {
                            break;     
                        }
                    }
                }          
                break;

            case cast(ubyte)']':
                if (0 != bfCells.getData()) {
                    int foo = 1; 
                    for (;;) {
                        bfCommands.decPtr();
                        switch (bfCommands.getData()) {
                            case cast(ubyte)']':
                                foo++;
                                break;    
                            case cast(ubyte)'[':
                                foo--;
                                break;
                            default:    
                        }                            
                        if (0 == foo) {
                            break;     
                        }
                    }
                }          
                break;
            
            default:
            
        }
        
        if (!bfCommands.incPtr()) {
            writeln("\n\nFinal State:");
            writefln("Cells: %s", bfCells.dataArray);
            writefln("Ptr: %s", bfCells.dataPtr);
            
            break;
        }                        
    }
}    
