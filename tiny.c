#include "tiny.h"
int symbolNumber=0;
int tempNumber=0;
int labelNumber=0;
int strNumber=0;

Node* newNode(nodeType t)
{
	Node* p=(Node*)malloc(sizeof(Node));
	if(p==NULL)
	{
		printf("memory allocate fail");
		return NULL;
	}
	else
	{
		p->type=t;
		p->op=0;
		p->entry=0;
		p->vtype=0;
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
		parent->noChild++;
	}
}
void printTree(Node* t){
	if(t!=NULL)
	{
		int lbn;
		Node *s;
		Node *idchild;
		Node *expchild;
		Node *strchild;
		Node *lchild;
		Node *rchild;
		switch(t->type)
		{
			case stmt:
			{
				switch(t->op)
				{
					case assign:
					{
						idchild=t->child;
						expchild=idchild->sibling;
						printTree(expchild);
						printf("id%d = t%d\n",idchild->entry,expchild->entry);
						break;
					}
					case stmts:
					{
						s=t->child;
						for(int i=0;i<(t->noChild);i++)
						{
							printTree(s);
							s=s->sibling;
						}
						break;
					}
					case prog:
					{
						s=t->child;
						for(int i=0;i<(t->noChild);i++)
						{
							printTree(s);
							s=s->sibling;
						}
						break;
					}
					case ret:
					{
						s=t->child;
						printf("return id%d\n",s->entry);
						break;
					}
					case rd:
					{
						idchild=t->child;
						strchild=idchild->sibling;
						printf("read id%d str%d\n",idchild->entry,strchild->entry);
						break;
					}	
					case wrt:
					{
						expchild=t->child;
						strchild=expchild->sibling;
						if(expchild->type==exp)
						{
							printTree(expchild);
							printf("write t%d str%d\n",expchild->entry,strchild->entry);
						}
						else if(expchild->type==id)
						{
							printf("write id%d str%d\n",expchild->entry,strchild->entry);
						}
						else
						{
							printf("write ");
							printTree(expchild);
							printf("str%d\n",strchild->entry);
						}
						break;
					}
					case ifstmt:
					{
						if(t->noChild==2)
						{
							lbn=labelNumber;
							labelNumber++;
							expchild=t->child;
							s=expchild->sibling;
							printTree(expchild);
							printf("if_false t%d goto L%d\n",expchild->entry,lbn);
							printTree(s);
							printf("label L%d\n",lbn);
						}
						else if(t->noChild==3)
						{
							lbn=labelNumber;
							labelNumber++;
							expchild=t->child;
							lchild=expchild->sibling;
							rchild=lchild->sibling;
							printTree(expchild);
							printf("if_false t%d goto L%d\n",expchild->entry,lbn);
							printTree(lchild);
							printf("Label L%d\n",lbn);
							printTree(rchild);
						}
						else
							printf("ifstmt have too many blocks\n");
						break;
					}
					case whilestmt:
					{
						lbn=labelNumber;
						labelNumber+=2;
						expchild=t->child;
						s=expchild->sibling;
						printf("label L%d\n",lbn);
						printTree(expchild);
						printf("if t%d goto L%d\n",expchild->entry,lbn+1);
						printTree(s);
						printf("goto L%d\n",lbn);
						printf("label L%d\n",lbn+1);
						labelNumber+=2;
						break;
					}
					case dostmt:
					{
						lbn=labelNumber;
						labelNumber++;
						s=t->child;
						expchild=s->sibling;
						printf("label L%d\n",lbn);
						printTree(s);
						printTree(expchild);
						printf("if t%d goto L%d\n",expchild->entry,lbn);
						break;
					}
					case forto:
					{
						lbn=labelNumber;
						labelNumber+=2;
						idchild=t->child;
						lchild=idchild->sibling;
						rchild=lchild->sibling;
						s=rchild->sibling;
						if(lchild->type==exp)
						{
							printTree(lchild);
							printf("id%d = t%d\n",idchild->entry,lchild->entry);
						}
						else if(lchild->type==id)
						{
							printf("id%d = id%d\n",idchild->entry,lchild->entry);
						}
						else
						{
							printf("id%d = ",idchild->entry);
							printTree(lchild);
							printf("\n");
						}
						if(rchild->type==exp)
						{
							printTree(rchild);
							printf("label L%d\n",lbn);
							printf("t%d = id%d == t%d\n",tempNumber,idchild->entry,rchild->entry);
						}
						else if(rchild->type==id)
						{
							printf("label L%d\n",lbn);
							printf("t%d = id%d == id%d\n",tempNumber,idchild->entry,rchild->entry);
						}
						else
						{
							printf("label L%d\n",lbn);
							printf("t%d = id%d == ",tempNumber,idchild->entry);
							printTree(rchild);
							printf("\n");
						}
						printf("if t%d goto L%d\n",tempNumber++,lbn+1);
						printTree(s);
						printf("id%d = id%d + 1\n",idchild->entry,idchild->entry);
						printf("goto L%d\n",lbn);
						printf("label L%d\n",lbn+1);
						break;
					}	
					case fordownto:
					{
						lbn=labelNumber;
						labelNumber+=2;
						idchild=t->child;
						lchild=idchild->sibling;
						rchild=lchild->sibling;
						s=rchild->sibling;
						if(lchild->type==exp)
						{
							printTree(lchild);
							printf("id%d = t%d\n",idchild->entry,lchild->entry);
						}
						else if(lchild->type==id)
						{
							printf("id%d = id%d\n",idchild->entry,lchild->entry);
						}
						else
						{
							printf("id%d = ",idchild->entry);
							printTree(lchild);
							printf("\n");
						}
						if(rchild->type==exp)
						{
							printTree(rchild);
							printf("label L%d\n",lbn);
							printf("t%d = id%d == t%d\n",tempNumber,idchild->entry,rchild->entry);
						}
						else if(rchild->type==id)
						{
							printf("label L%d\n",lbn);
							printf("t%d = id%d == id%d\n",tempNumber,idchild->entry,rchild->entry);
						}
						else
						{
							printf("label L%d\n",lbn);
							printf("t%d = id%d == ",tempNumber,idchild->entry);
							printTree(rchild);
							printf("\n");
						}
						printf("if t%d goto L%d\n",tempNumber++,lbn+1);
						printTree(s);
						printf("id%d = id%d - 1\n",idchild->entry,idchild->entry);
						printf("goto L%d\n",lbn);
						printf("label L%d\n",lbn+1);
						break;
					}
					default:
						printf("op: %d",t->op);
						break;
				}
						
				break;
			}
			case exp:
			{
				
				t->entry=tempNumber++;
				switch(t->op)
				{
					case add:
					{
						genExp(t,add);
						break;
					}
					case sub:
					{
						genExp(t,sub);
						break;

					}
					case mult:
					{
						genExp(t,mult);
						break;
					}
					case dv:
					{
						genExp(t,dv);
						break;
					}
					case eql:
					{
						genExp(t,eql);
						break;
					}
					case neq:
					{
						genExp(t,neq);
						break;
					}
					case call:
					{
						idchild=t->child;
						s=idchild->sibling;
						if(t->noChild==1)
							printf("call id%d\n",idchild->entry);
						else if(t->noChild==2)
						{
							printTree(s);
							printf("call id%d\n",idchild->entry);
						}
						break;
					}
					case param:
					{
						s=t->child;
						for(int i=0;i<(t->noChild);i++)
						{
							if(s->type==exp)
							{
								printTree(s);
								printf("param t%d\n",s->entry);
							}
							else if(s->type==id)
							{
								printf("param id%d\n",s->entry);
							}
							else 
							{
								printf("param ");
								printTree(s);
								printf("\n");
							}
							s=s->sibling;
						}
						break;
					}
					default:
						break;
				}
				break;
			}
			case id:
			{
				printf("id%d ",t->entry);
				break;
			}
			case con:
			{
				switch(t->vtype)
				{
					case intType:
					{
						printf("%d ",t->val.intNum);
						break;
					}
					case realType:
					{
						printf("%f ",t->val.realNum);
						break;
					}
					default:
						break;
				}
				break;
			}
			default:
				break;
		}
	}
}
int find(char* name){
	for(int i=0;i<symbolNumber;i++)
	{
		if(strcmp(name,sym[i].name)==0)
			return i;
	}
	strcpy(sym[symbolNumber].name,name);
	int ent=symbolNumber;
	symbolNumber++;
	return ent;
}
int storeStr(char* str){
	
	strcpy(strs[strNumber],str);
	int ent=strNumber++;
	return ent;
}
void genExp(Node* t,oprType op){
	Node* lchild=t->child;
	Node* rchild=lchild->sibling;
	char *oper;
	switch(op)
	{
		case add:
			oper="+";
			break;
		case sub:
			oper="-";
			break;
		case mult:
			oper="*";
			break;
		case dv:
			oper="/";
			break;
		case eql:
			oper="==";
			break;
		case neq:
			oper="!=";
			break;
		default:
			break;
	}
	if(lchild->type==exp)
	{
		if(rchild->type==exp)
		{
			printTree(lchild);
			printTree(rchild);
			printf("t%d = t%d %s t%d\n",t->entry,lchild->entry,oper,rchild->entry);
		}
		else
		{
		printTree(lchild);
		printf("t%d = t%d %s ",t->entry,lchild->entry,oper);
		printTree(rchild);
		printf("\n");
		}
	}
	else
	{
		if(rchild->type==exp)
		{
			printTree(rchild);
			printf("t%d = ",t->entry);
			printTree(lchild);
			printf("%s t%d\n",oper,rchild->entry);
		}
		else
		{
			printf("t%d = ",t->entry);
			printTree(lchild);
			printf("%s ",oper);
			printTree(rchild);
			printf("\n");
		}
	}
}

