# Lab_N_D238U
Network Lab Docker-compose
## Setup
1. Enter the folder with the docker-compose.yml file

2. `docker-compose build`

3. `docker-compose up -d`

4. if linux: `chmod +x after/net.sh`

5. if linux : `./after/net.sh` if windows:  `.\after\net.bat`

## Tests
- Enter the technicians client:
`docker exec -it dockerlab_n-technicians_client-1 /bin/sh`
- Connect to tech database:
`mysql -h 10.0.12.10 -u root -p`
Password: techpass
- Connect to internal database:
`mysql -h 10.0.2.10 -u root -p`
Password: example
- Exit the tech client
### It should work

------------
- Enter the internal database:
`docker exec -it dockerlab_n-internal_db-1 /bin/sh`
- Try to connect to technicians database:
`mysql -h 10.0.12.10 -u root -p`
Password: techpass
### It should not work





