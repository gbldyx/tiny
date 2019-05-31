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
		//p->name=name;
		strcpy(p->name,name);
		//printf("%s\n",name);
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
		//printf("parent: %s  child: %s\n",parent->name,parent->child->name);
	}
	else
	{
		p=parent->child;
		for(int i=1;i<(parent->noChild);i++)
		{
			p=p->sibling;
		}
		p->sibling=child;
		parent->noChild++;
		//printf("parent: %s  child: %s  sibling: %s\n",parent->name,parent->child->name,p->sibling->name);
	}
}
void printTree(Node* t,int depth){
	if(t!=NULL)
	{
		Node* s=t->child;
		for(int i=0;i<depth;i++)
		{
			printf(" ");
		}
		printf("%s\n",t->name);
		printTree(s,depth+1);
		for(int i=1;i<(t->noChild);i++)
		{
			printTree(s->sibling,depth+1);
			s=s->sibling;
		}
	}
}

