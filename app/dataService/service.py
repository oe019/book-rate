from app.UI.dto import userDTO
from app.dataModel.user import user
from app.DtoModelMapper.mapper import DTOuser_userDB

def insert(userdto):
    usr = DTOuser_userDB(userDTO)


