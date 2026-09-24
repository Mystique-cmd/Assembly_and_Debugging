For this lab the point is to simply avoid the nulls in the code. instead of using instruction such as ` mov rdi, 0 `
For checking for the  null byte automatically one can also use python as follows
```python
	python3 -c 'data=open("shellcode.bin","rb").read(); print("null bytes:".data.count(b"\x00"))'
```

The results produced by the different instruction is the same , the difference is the machine code representation.
