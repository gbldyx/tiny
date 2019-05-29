#include "tiny.h"
Node* newNode(char* name)
{
	Node* p=(Node*)malloc(sizeof(Node));
	if(p==NULL)
	{
		printf("memory allocate fail");
		return NULL;
	}
	else
	{
		p->name=name;
		p->child=NULL;
		p->sibling=NULL;
		p->noChild=0;
		return p;
	}
}	
void insert(Node* parent,Node* child)
{
	Node* p;
	if(parent->child==NULL)
	{
		parent->child=child;
		parent->noChild++;
	}
	else
	{
		p=parent->child;
		for(int i=1;i<(parent->noChild);i++)
		{
			p=p->sibling;
		}
		p->sibling=child;
		p->noChild++;
	}
}
void printTree(Node* t){
	if(t!=NULL)
	{
		Node* s=t->child;
		printf("%s\n",t->name);
		printTree(s);
		for(int i=1;i<(t->noChild);i++)
		{
			printTree(s->sibling);
			s=s->sibling;
		}
	}
}

