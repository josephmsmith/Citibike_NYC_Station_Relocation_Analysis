/* Cleaning data in PostgreSQL for Portfolio */ 

------------------------------------------------------------------------------------------------------------------
--Pull in data from external database

CREATE TABLE nv_housing_data(  --Create Table
UniqueID numeric PRIMARY KEY,
ParcelID text,
LandUse text,
PropertyAddress text,
SaleDate timestamp,
SalePrice text,
LegalReference text,
SoldAsVacant text,
OwnerName text,
OwnerAddress text,
Acreage numeric,
TaxDistrict text,
LandValue numeric,
BuildingValue numeric,
TotalValue numeric,
YearBuilt numeric,
Bedrooms numeric,
FullBath numeric,
HalfBath numeric
);

--copy data from file into the database
COPY nv_housing_data(UniqueID ,ParcelID ,LandUse ,PropertyAddress ,SaleDate ,SalePrice ,LegalReference ,SoldAsVacant ,OwnerName ,OwnerAddress , 
					  Acreage ,TaxDistrict ,LandValue ,BuildingValue ,TotalValue ,YearBuilt, Bedrooms, FullBath, HalfBath)
FROM 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\Nashville Housing Data for Data Cleaning.csv' delimiter ',' csv header;

DROP TABLE nv_housing_data

----------------------------------------------------------------------------------------------------------------
--Step 1 Standarize date format. Eliminate timezone.

SELECT saledate, saledate::DATE --visualize what we want the next column to look like
FROM public.nv_housing_data;

ALTER table public.nv_housing_data --add new column
ADD SaleDateConverted DATE;

UPDATE public.nv_housing_data --Equation
SET saledateconverted = saledate::DATE;

SELECT saledate, saledateconverted --visual check to confirm
FROM public.nv_housing_data;

ALTER table public.nv_housing_data --drop old saledate column
DROP SaleDate;

----------------------------------------------------------------------------------------------------------------
--Step 2 Populate property address data

--check for nulls
SELECT propertyaddress, parcelid
FROM public.nv_housing_data
WHERE propertyaddress is null
ORDER BY parcelid
--we found the parcel ID is directly associate with the propertyaddress

--check for how many addresses have null (29)
SELECT a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, COALESCE(a.propertyaddress, b.propertyaddress) propertyaddress2
FROM public.nv_housing_data a
	JOIN public.nv_housing_data b
	ON a.parcelid = b.parcelid
	AND A.uniqueid <> b.uniqueid
where a.propertyaddress is null;

--update to the table and replace empty addresses with populated ones
UPDATE public.nv_housing_data
SET propertyaddress = b.propertyaddress
FROM public.nv_housing_data a
		JOIN public.nv_housing_data b
		ON a.parcelid = b.parcelid
		AND a.uniqueid <> b.uniqueid
 WHERE a.propertyaddress IS null;
 
UPDATE public.nv_housing_data A
  SET PROPERTYADDRESS = B.PROPERTYADDRESS
FROM public.nv_housing_data B 
WHERE A.UNIQUEID != B.UNIQUEID
  AND A.PARCELID = B.PARCELID
  AND A.PROPERTYADDRESS IS NULL

select distinct propertyaddress
from public.nv_housing_data

select *
from public.nv_housing_data
limit 100;

----------------------------------------------------------------------------------------------------------------
--Step 3 Breaking address column into indivual columns (add, city, state)

SELECT propertyaddress
FROM public.nv_housing_data;

SELECT 
SUBSTRING(propertyaddress,0,strpos(propertyaddress,',')-1) Address,
SUBSTRING(propertyaddress,strpos(propertyaddress,',')+1, LENGTH(propertyaddress))
FROM public.nv_housing_data


ALTER table public.nv_housing_data --add new column
ADD PropertySplitAddress varchar;

UPDATE public.nv_housing_data --Equation
SET PropertySplitAddress = SUBSTRING(propertyaddress,0,strpos(propertyaddress,',')-1);

ALTER table public.nv_housing_data --add new column
ADD PropertySplitCity varchar;

UPDATE public.nv_housing_data --Equation
SET PropertySplitCity = SUBSTRING(propertyaddress,strpos(propertyaddress,',')+1, LENGTH(propertyaddress));

--VISUAL CHECK
SELECT *
FROM public.nv_housing_data
LIMIT 10;

----------------------------------------------------------------------------------------------------------------
--Step 4 changing owner address into usable format
SELECT owneraddress
FROM public.nv_housing_data;

SELECT 
SUBSTRING(owneraddress,0,strpos(owneraddress,',')-1),
SUBSTRING(owneraddress,strpos(owneraddress,',')+1, LENGTH(owneraddress))
FROM public.nv_housing_data


ALTER table public.nv_housing_data --add new column
ADD OwnerSplitAddress varchar;

UPDATE public.nv_housing_data --Equation
SET OwnerSplitAddress = SUBSTRING(owneraddress,0,strpos(owneraddress,',')-1);

ALTER table public.nv_housing_data --add new column
ADD OwnerSplitCity varchar;

UPDATE public.nv_housing_data --Equation
SET OwnerSplitCity = SUBSTRING(owneraddress,strpos(owneraddress,',')+1, LENGTH(owneraddress));



ALTER table public.nv_housing_data --add new column
ADD PropertySplitCity varchar;

UPDATE public.nv_housing_data --Equation
SET PropertySplitCity = SUBSTRING(propertyaddress,strpos(propertyaddress,',')+1, LENGTH(propertyaddress));


