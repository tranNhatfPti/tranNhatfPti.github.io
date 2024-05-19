package model;

public class Shipper {
    private int ShipperID;
    private String Phone, companyName, country;

    public Shipper() {
    }

    public Shipper(String Phone, String companyName, String country) {
        this.Phone = Phone;
        this.companyName = companyName;
        this.country = country;
    }   

    public Shipper(int ShipperID, String Phone, String companyName, String country) {
        this.ShipperID = ShipperID;
        this.Phone = Phone;
        this.companyName = companyName;
        this.country = country;
    }

    public int getShipperID() {
        return ShipperID;
    }

    public void setShipperID(int ShipperID) {
        this.ShipperID = ShipperID;
    }

    public String getPhone() {
        return Phone;
    }

    public void setPhone(String Phone) {
        this.Phone = Phone;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }
    
    
}
