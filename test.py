n=5

a=[]

for i in range(0,n):
    tmp=[]
    for j in range(0,n):
        tmp.append(0)
    a.append(tmp)

g=1

for l in range(0,int((n+1)/2)):
    si=0
    sj=int(n/2)-l
    f=0
    print("l",l)
    print("si",si)
    print("sj",sj)
    print("*****")
    for k in range(1,(2*l)+2):
        print(si)
        print(sj)
        print("-----")
        a[si][sj]=g
        g=g+1
        sj=sj+1
        if f==0:
            si=si+1
        else:
            si=si-1
        if sj==int(n/2):
            f=1
    


for i in range(1,n):
    si=i
    sj=0
    f=0
    for j in range(n):
        if si<n and sj<n:
            a[si][sj]=g
            g=g+1
        sj=sj+1
        if f==0:
            si=si+1
        else:
            si=si-1
        if sj==int(n/2):
            f=1



for i in range(n-1,-1,-1):
    print(a[i])
    


