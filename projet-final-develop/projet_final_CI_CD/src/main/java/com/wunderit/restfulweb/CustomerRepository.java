package com.wunderit.restfulweb;

import org.springframework.data.mongodb.repository.MongoRepository;

public interface CustomerRepository extends MongoRepository<Customer, String> {

    public Customer findByLastName(String lastName);

}