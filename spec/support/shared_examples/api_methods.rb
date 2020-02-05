shared_examples_for 'API resources list returnable' do
  before { get api_path, params: { access_token: access_token.token },
                         headers: headers }

  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'returns list of resources' do
    expect(resources_response.size).to eq resources.size
  end

  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end

  it 'contains user object' do
    expect(resource_response['user']['id']).to eq resource.user.id
  end
end

shared_examples_for 'API resource returnable' do
  before { get api_path,
           params: { access_token: access_token.token },
           headers: headers }

  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end

  describe 'comments' do
    let(:comment) { comments.first }
    let(:comment_response) { resource_response['comments'].first }

    it 'returns list of comments' do
      expect(resource_response['comments'].size).to eq comments.size
    end

    it 'returns all public fields' do
      %w(id body user_id commentable_type commentable_id created_at updated_at).each do |attr|
        expect(comment_response[attr]).to eq comment.send(attr).as_json
      end
    end
  end

  describe 'files' do
    let(:file) { resource.files.first }
    let(:file_response) { resource_response['files'].first }

    it 'returns list of files' do
      expect(resource_response['files'].size).to eq resource.files.count
    end

    it 'returns all public fields' do
      expect(file_response['id']).to eq file.id
      expect(file_response['name']).to eq file.filename.to_s
      expect(file_response['url']).to eq rails_blob_path(file, only_path: true)
    end
  end

  describe 'links' do
    let(:link) { links.last }
    let(:link_response) { resource_response['links'].first }

    it 'returns list of links' do
      expect(resource_response['links'].size).to eq links.size
    end

    it 'returns all public fields' do
      %w(id name url linkable_type linkable_id created_at updated_at).each do |attr|
        expect(link_response[attr]).to eq link.send(attr).as_json
      end
    end
  end
end

shared_examples_for 'API resource creatable' do
  context 'with valid attributes' do
    it 'saves a new resource in database' do
      expect { do_valid_request }.to change(resource_class, :count).by(1)
    end

    it 'returns resource with right attributes' do
      do_valid_request

      resource_params.each do |key, value|
        expect(resource_response[key.to_s]).to eq value
      end
    end

    it 'returns all public fields' do
      do_valid_request

      public_fields.each do |attr|
        expect(resource_response).to have_key(attr)
      end
    end

    it 'returns 201 status' do
      do_valid_request
      expect(response.status).to eq 201
    end
  end

  context 'with invalid attributes' do                               
    it 'does not saves a new resource in database' do
      expect { do_invalid_request }.to_not change(resource_class, :count)
    end

    it 'returns 422 status' do
      do_invalid_request
      expect(response.status).to eq 422
    end
  end
end

shared_examples_for 'API resource updatable' do
  context 'with valid attributes' do
    before { do_valid_request }

    it 'changes resource attributes' do
      resource.reload

      resource_params.each do |key, value|
        expect(resource.send(key)).to eq value
      end
    end

    it 'returns resource with updated attributes' do
      resource_params.each do |key, value|
        expect(resource_response[key.to_s]).to eq value
      end
    end

    it 'returns all public fields' do
      resource.reload

      public_fields.each do |attr|
        expect(resource_response[attr]).to eq resource.send(attr).as_json
      end
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end
  end

  context 'with invalid attributes' do
    before { do_invalid_request }

    it 'does not changes resource attributes' do
      resource.reload

      resource_params.each_key do |key|
        expect(resource.send(key)).to eq resource.send(key)
      end
    end

    it 'returns 422 status' do
      expect(response.status).to eq 422
    end
  end

  context 'for not the author of the resource' do
    before { do_not_author_request }

    it 'does not changes resource attributes' do
      resource.reload

      resource_params.each_key do |key|
        expect(resource.send(key)).to eq resource.send(key)
      end
    end

    it 'returns unsuccessful status' do
      expect(response).to_not be_successful
    end
  end
end

shared_examples_for 'API resource destroyable' do
  context 'for the author of the resource' do
    it 'deletes the resource from database' do
      expect { do_valid_request }.to change(resource_class, :count).by(-1)
    end

    it 'returns 200 status' do
      do_valid_request
      expect(response).to be_successful
    end
  end

  context 'for not the author of the resource' do
    it 'does not deletes the resource from database' do
      expect { do_not_author_request }.to_not change(resource_class, :count)
    end

    it 'returns unsuccessful status' do
      do_not_author_request
      expect(response).to_not be_successful
    end
  end
end
