%%%%%%%%%%%%%%%%%%%%%%%%%导入城市的x, y坐标矩阵%%%%%%%%%%%%%%%%
ori=dlmread('city_51.txt');
only_location=zeros(51,2);
only_location=ori(:,2:3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%初始参数设置%%%%%%%%%%%%%%%%%%%%%%
maxcur=3;%%最大迭代次数
m=10;%%放置蚂蚁的个数
q0=0.9;
beita=2;
aerfa=0.1;
city_distance=zeros(51,51);%%两两城市之间的距离
city_pheromone=zeros(51,51);%%两两城市之间的信息素浓度
Lnn=636.84;%%贪心算法Lnn的距离，用来初始化phermone的  

city_totalnum=zeros(1,51);%%建立一个1~51的城市序号向量，后面调用randsample会用到
for r=1:1:51
city_totalnum(r)=r;
end

%%%%%%%%%%%%%%%%%%%计算两个城市之间的距离和信息素%%%%%%%%%%%%%%%%%%
for i=1:1:51
for j=1:1:51
city_distance(i,j)=(only_location(i,1)-only_location(j,1))^2;
city_distance(i,j)=city_distance(i,j)+(only_location(i,2)-only_location(j,2))^2;
city_distance(i,j)=sqrt(city_distance(i,j));%%录入距离
city_pheromone(i,j)=power(51*Lnn,-1);%录入初始信息素

end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%小蚂蚁们开始干活%%%%%%%%%%%%%%%%%%
for total=1:1:maxcur
for ant_number=1:1:m %%%%放置m只蚂蚁

begin_city=round(rand*50+1);%%随机放置一个起始城市
tour=zeros(51,1);%%用来表示走过的城市的序号
tour(1,1)=begin_city;
tmp_pheromone=city_pheromone(begin_city,:);%%每个蚂蚁开始前，给它一个镜像的城市信息素信息表
tmp_pheromone(begin_city)=0;
tmp_para=zeros(1,51);


for jj=1:1:51  %%录入镜像的参数
    tmp_para(jj)=tmp_pheromone(jj)/city_distance(begin_city,jj)^beita;   
end
tmp_para(begin_city)=0;
sum_tmp_para=sum(tmp_para);
tmp_para=tmp_para/sum_tmp_para;%%完成了对镜像参数的归一化（用来表示概率）

%%%%%%%%%%%%%%%%%%%开始求怎么走向下一个城市%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=2:1:51  

    q=rand;%%%%%%摇一个随机数%%%%%%
if q<=q0  %q小于等于q0，选择最优解
    [copara,city_num]=max(tmp_pheromone./(city_distance(tour(j-1),:)).^beita);
    tour(j)=city_num; 

else      %q大于q0，进行新道路开拓
    tour(j)=randsample(city_totalnum,1,true,tmp_para);   
end

tmp_pheromone(tour(j))=0;%%将对应城市的镜像信息素归零，表示这个城市已经走过了

%%%%%%%%%%%进行局部更行%%%%%%%%%%%%%%
city_pheromone(tour(j-1),tour(j))=city_pheromone(tour(j-1),tour(j))*(1-aerfa)+aerfa/(Lnn*51);

end 
%%%%%%%%%%%%%%%%%%%路径完成，保存在向量tour中%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%求出最后走出来路径的总长%%%%%%%%%%%%%%%%
tour_lengh=city_distance(tour(1),tour(51));
for r=1:1:50
tour_lengh=tour_lengh+city_distance(tour(r),tour(r+1));
end


%%%%%%%%%%%%%%%%%%%%%%开始进行全局更新%%%%%%%%%%%%%%%%%%%%
for r1=1:1:51 %%先对全局进行衰减的更新
    for c1=1:1:51
    city_pheromone(r1,c1)=city_pheromone(r1,c1)*(1-aerfa);
    end
end
for r3=1:1:50   %%再把最优路径那部分加上去
    
    city_pheromone(tour(r3),tour(r3+1))= city_pheromone(tour(r3),tour(r3+1))+aerfa/tour_lengh;
    city_pheromone(tour(1),tour(51))= city_pheromone(tour(1),tour(51))+aerfa/tour_lengh;
end          
 %%%%%%%%%%%%%%%%%%%全局更新完成%%%%%%%%%%%%%%%%%%%

 
end

end

%%%%%%%%%%%%%%%%%参数说明%%%%%%%%%%%%%%%%%

%begin_city是起始的城市， tour向量记录从begin_city开始一路走过的城市序号
%tour_lengh表示这一路走回起始的总距离











