FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
LABEL Author="Akhil"
LABEL Date="18/03/2025"
RUN git clone https://github.com/nopSolutions/nopCommerce.git
RUN cd /nopCommerce && mkdir published
WORKDIR /nopCommerce
RUN dotnet publish -c Release -o published/ src/Presentation/Nop.Web/Nop.Web.csproj
                                                                                                                             
FROM mcr.microsoft.com/dotnet/aspnet:9.0
RUN useradd -m -d /home/ubuntu -s /bin/bash ubuntu
RUN mkdir /home/ubuntu/nop && chown ubuntu:ubuntu /home/ubuntu/nop
USER ubuntu
COPY --from=build --chown=ubuntu:ubuntu /nopCommerce/ /home/ubuntu/nop
WORKDIR /home/ubuntu/nop/published
EXPOSE 5000
CMD ["dotnet", "Nop.Web.dll", "--urls", "http://0.0.0.0:5000"]