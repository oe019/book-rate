from app.UI.dto import userDTO
from app.dataModel.user import user

def DTOuser_userDB(userdto) -> user:
    if(type(userdto) is userDTO):
        raise exit(1);

    usr = user()
    usr.name = userdto.value1;
    usr.surname = userdto.value2;

    return usr;




