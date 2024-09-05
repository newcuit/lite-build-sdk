#include <stdio.h>
#include <example-lib.h>

int main(int argc, char *argv[])
{
	int index = 4;

	index = example_lib_call(index);
	printf("index = %d\n", index);

	return 0;
}
